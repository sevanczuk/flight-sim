"""GNC 355 PDF extraction script — GNC355-EXTRACT-01.

Extracts per-page text, images, and tables from the Garmin GNC 355 Pilot's Guide PDF.
Produces structured JSON + extracted images + extraction report.
"""

import argparse
import json
import os
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

# --- Dependency imports with clear error messages ---

try:
    import pdfplumber
except ImportError:
    sys.exit("Missing dependency: run: pip install pdfplumber")

try:
    from PIL import Image  # noqa: F401 — used via pdfplumber internally
except ImportError:
    sys.exit("Missing dependency: run: pip install Pillow")

try:
    import pytesseract
    _PYTESSERACT_IMPORTED = True
except ImportError:
    _PYTESSERACT_IMPORTED = False
    print("WARNING: pytesseract not importable. OCR will not be available.")

# --- Constants ---

DEFAULT_PDF = (
    Path(__file__).parent.parent
    / "assets"
    / "Garmin GNC 375 -  GPS 175 GNC 355 GNX 375 Pilot's Guide 190-02488-01_c.pdf"
)
DEFAULT_OUTPUT_DIR = Path(__file__).parent.parent / "assets" / "gnc355_pdf_extracted"

MAX_TABLE_ROWS = 20
MAX_TABLE_COLS = 10


# ---------------------------------------------------------------------------
# Pure helper functions (tested in isolation by test suite)
# ---------------------------------------------------------------------------


def tesseract_available() -> bool:
    """Return True if the Tesseract binary is reachable."""
    if not _PYTESSERACT_IMPORTED:
        return False
    try:
        pytesseract.get_tesseract_version()
        return True
    except Exception:
        return False


def get_text_confidence(char_count: int) -> str:
    """Map character count to confidence label."""
    if char_count >= 200:
        return "clean"
    if char_count >= 1:
        return "sparse"
    return "empty"


def format_image_filename(page: int, idx: int, ext: str) -> str:
    """Return image filename like page_0001_img_00.jpg."""
    return f"page_{page:04d}_img_{idx:02d}.{ext}"


def get_image_format(filter_name: str | None) -> str:
    """Map PDF image filter name to file extension."""
    if filter_name == "/DCTDecode":
        return "jpg"
    if filter_name == "/FlateDecode":
        return "png"
    return "bin"


def parse_page_range(pages_arg: str, total_pages: int) -> list[int]:
    """Parse --pages argument into a sorted list of 1-indexed page numbers.

    Supports: 'all', single page '5', single range '1-10',
    comma-separated combination '1-5,10,20-25'.
    """
    if pages_arg == "all":
        return list(range(1, total_pages + 1))

    result = set()
    for segment in pages_arg.split(","):
        segment = segment.strip()
        if "-" in segment:
            parts = segment.split("-", 1)
            start, end = int(parts[0]), int(parts[1])
            result.update(range(start, end + 1))
        else:
            result.add(int(segment))

    return sorted(p for p in result if 1 <= p <= total_pages)


def should_truncate_table(rows: int, cols: int) -> bool:
    """Return True if the table is too large to inline."""
    return rows > MAX_TABLE_ROWS or cols > MAX_TABLE_COLS


# ---------------------------------------------------------------------------
# Per-page extraction functions
# ---------------------------------------------------------------------------


def extract_page_text(page, page_num: int, ocr_mode: str, tess_available: bool) -> dict:
    """Extract text from a single pdfplumber page object."""
    warnings = []
    raw_text = page.extract_text() or ""
    char_count = len(raw_text)
    confidence = get_text_confidence(char_count)
    method = "pdfplumber"
    ocr_applied = False
    ocr_text = None

    needs_ocr = confidence in ("sparse", "empty")
    can_ocr = tess_available and ocr_mode in ("auto", "force")
    do_ocr = (needs_ocr and ocr_mode == "auto" and can_ocr) or (ocr_mode == "force" and can_ocr)

    if do_ocr:
        try:
            img = page.to_image(resolution=300).original
            ocr_result = pytesseract.image_to_string(img)
            ocr_char_count = len(ocr_result)
            if ocr_char_count > char_count:
                ocr_text = ocr_result
                if char_count > 0:
                    method = "pdfplumber+ocr"
                else:
                    method = "ocr"
                raw_text = ocr_result
                char_count = ocr_char_count
                confidence = get_text_confidence(char_count)
            ocr_applied = True
        except Exception as exc:
            warnings.append(f"OCR failed: {exc}")
    elif needs_ocr and not tess_available:
        warnings.append("text-extraction-gap, OCR unavailable")

    result = {
        "page_number": page_num,
        "text": raw_text,
        "text_char_count": char_count,
        "text_confidence": confidence,
        "extraction_method": method,
        "ocr_applied": ocr_applied,
        "warnings": warnings,
    }
    if ocr_text is not None:
        result["text_ocr"] = ocr_text
    return result


def extract_page_images(page, page_num: int, images_dir: Path, min_bytes: int) -> list[dict]:
    """Extract embedded images from a single pdfplumber page object."""
    extracted = []
    for idx, img_obj in enumerate(page.images):
        try:
            # Retrieve raw image bytes from the PDF object stream
            pdf_obj = img_obj.get("stream")
            if pdf_obj is None:
                # pdfplumber stores image reference; access via page's pdf object
                ref = img_obj.get("name") or img_obj.get("object_type")
                # Attempt to get the raw data via the page's parent PDF
                pdf_page = page.page_obj
                img_data = None
                # Try to extract via pdfplumber's underlying pypdfium2/pdfminer backend
                # pdfplumber image dict contains 'stream' for inline images; for XObjects
                # we use the page.pdf.stream approach
                xobjs = pdf_page.get("Resources", {}).get("XObject", {})
                img_name = img_obj.get("name")
                if img_name and img_name in xobjs:
                    xobj = xobjs[img_name].get_object()
                    if hasattr(xobj, "get_data"):
                        img_data = xobj.get_data()
                    elif hasattr(xobj, "rawdata"):
                        img_data = xobj.rawdata
            else:
                img_data = pdf_obj.get_data() if hasattr(pdf_obj, "get_data") else None

            if not img_data:
                # Fallback: render the image region via PIL
                bbox = (img_obj["x0"], img_obj["top"], img_obj["x1"], img_obj["bottom"])
                cropped = page.within_bbox(bbox).to_image(resolution=150).original
                import io
                buf = io.BytesIO()
                cropped.save(buf, format="PNG")
                img_data = buf.getvalue()
                img_format = "png"
                filter_name = "/FlateDecode"
            else:
                filter_name = img_obj.get("filter")
                if isinstance(filter_name, list):
                    filter_name = filter_name[0] if filter_name else None
                img_format = get_image_format(filter_name)

            byte_size = len(img_data)
            if byte_size < min_bytes:
                continue

            filename = format_image_filename(page_num, idx, img_format)
            dest_path = images_dir / filename
            dest_path.write_bytes(img_data)

            extracted.append({
                "index": idx,
                "filename": f"images/{filename}",
                "bbox": (img_obj["x0"], img_obj["top"], img_obj["x1"], img_obj["bottom"]),
                "width_px": int(img_obj.get("width", 0)),
                "height_px": int(img_obj.get("height", 0)),
                "byte_size": byte_size,
                "format": img_format,
            })
        except Exception as exc:
            # Log warning but don't crash the whole extraction
            extracted.append({
                "index": idx,
                "warning": f"image extraction failed: {exc}",
            })

    return extracted


def extract_page_tables(page) -> list[dict]:
    """Extract tables from a single pdfplumber page object."""
    tables = []
    try:
        raw_tables = page.extract_tables()
    except Exception:
        return tables

    for idx, table_data in enumerate(raw_tables):
        if not table_data:
            continue
        rows = len(table_data)
        cols = max((len(row) for row in table_data), default=0)
        truncated = should_truncate_table(rows, cols)

        # Estimate bbox from table finder if available
        try:
            finder = page.find_tables()
            bbox = finder[idx].bbox if idx < len(finder) else None
        except Exception:
            bbox = None

        entry = {
            "index": idx,
            "bbox": bbox,
            "rows": rows,
            "cols": cols,
            "data": None if truncated else table_data,
            "truncated": truncated,
        }
        tables.append(entry)

    return tables


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------


def main():
    parser = argparse.ArgumentParser(description="Extract text, images, and tables from Garmin GNC 355 Pilot's Guide.")
    parser.add_argument("--pdf", type=Path, default=DEFAULT_PDF, help="Path to source PDF")
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR, help="Output directory")
    parser.add_argument(
        "--ocr",
        default="auto",
        choices=["auto", "force", "off"],
        help="OCR mode: auto=sparse/empty pages only, force=all pages, off=never",
    )
    parser.add_argument(
        "--image-min-bytes",
        type=int,
        default=1024,
        help="Skip images smaller than this byte size (default 1024)",
    )
    parser.add_argument(
        "--pages",
        default="all",
        help="Page range: 'all', '1-50', '5', or '1-5,10,20-25'",
    )
    args = parser.parse_args()

    pdf_path = args.pdf
    output_dir = args.output_dir
    images_dir = output_dir / "images"

    # --- Startup checks ---
    if not pdf_path.exists():
        sys.exit(f"PDF not found: {pdf_path}")

    tess = tesseract_available()
    print(f"Tesseract available: {tess}")
    if not tess:
        print("  OCR fallback disabled. Pages with sparse/empty text will be flagged.")

    output_dir.mkdir(parents=True, exist_ok=True)
    images_dir.mkdir(parents=True, exist_ok=True)

    start_time = time.monotonic()
    extracted_at = datetime.now(timezone.utc).isoformat()

    all_pages = []
    stats = {
        "clean": 0,
        "sparse": 0,
        "empty": 0,
        "ocr_applied": 0,
        "images_extracted": 0,
        "tables_detected": 0,
        "tables_truncated": 0,
        "pages_with_warnings": [],
        "low_confidence_pages": [],
    }

    with pdfplumber.open(pdf_path) as pdf:
        total_pages = len(pdf.pages)
        page_list = parse_page_range(args.pages, total_pages)
        pages_processed = len(page_list)
        print(f"PDF opened: {total_pages} pages total, processing {pages_processed} pages.")

        for i, page_num in enumerate(page_list, 1):
            page = pdf.pages[page_num - 1]  # 0-indexed

            text_data = extract_page_text(page, page_num, args.ocr, tess)
            images_data = extract_page_images(page, page_num, images_dir, args.image_min_bytes)
            tables_data = extract_page_tables(page)

            page_dict = {**text_data, "images": images_data, "tables": tables_data}
            all_pages.append(page_dict)

            conf = text_data["text_confidence"]
            stats[conf] += 1
            if text_data["ocr_applied"]:
                stats["ocr_applied"] += 1

            real_images = [img for img in images_data if "warning" not in img]
            stats["images_extracted"] += len(real_images)
            stats["tables_detected"] += len(tables_data)
            stats["tables_truncated"] += sum(1 for t in tables_data if t.get("truncated"))

            if conf != "clean":
                stats["low_confidence_pages"].append({"page": page_num, "confidence": conf})

            if text_data["warnings"]:
                stats["pages_with_warnings"].append(page_num)

            if i % 10 == 0 or i == pages_processed:
                img_count = len(real_images)
                tbl_count = len(tables_data)
                print(
                    f"processed page {page_num}/{total_pages}: "
                    f"{conf} text, {img_count} images, {tbl_count} tables"
                )

    elapsed = time.monotonic() - start_time

    # --- Write text_by_page.json ---
    output_json = {
        "source_pdf": str(pdf_path.relative_to(pdf_path.parent.parent)).replace("\\", "/"),
        "extracted_at": extracted_at,
        "page_count": total_pages,
        "pages_processed": pages_processed,
        "tesseract_available": tess,
        "ocr_mode": args.ocr,
        "image_min_bytes": args.image_min_bytes,
        "pages": all_pages,
    }
    json_path = output_dir / "text_by_page.json"
    json_path.write_text(json.dumps(output_json, indent=2, default=str), encoding="utf-8")

    # --- Compute output directory size ---
    total_bytes = sum(f.stat().st_size for f in output_dir.rglob("*") if f.is_file())
    total_mb = total_bytes / (1024 * 1024)

    # --- Write extraction_report.md ---
    report_lines = [
        "---",
        "Created: " + extracted_at,
        "Source: docs/tasks/gnc355_pdf_extract_prompt.md",
        "---",
        "",
        "# GNC 355 PDF Extraction Report",
        "",
        "## Summary Statistics",
        "",
        f"| Metric | Value |",
        f"|--------|-------|",
        f"| Source PDF | {pdf_path.name} |",
        f"| Total pages in PDF | {total_pages} |",
        f"| Pages processed | {pages_processed} |",
        f"| Clean text pages | {stats['clean']} |",
        f"| Sparse text pages | {stats['sparse']} |",
        f"| Empty text pages | {stats['empty']} |",
        f"| OCR-applied pages | {stats['ocr_applied']} |",
        f"| Total images extracted | {stats['images_extracted']} |",
        f"| Total tables detected | {stats['tables_detected']} |",
        f"| Truncated tables (too large to inline) | {stats['tables_truncated']} |",
        f"| Tesseract available | {tess} |",
        f"| OCR mode | {args.ocr} |",
        f"| Total output size | {total_mb:.1f} MB |",
        f"| Wall-clock duration | {elapsed:.1f} s |",
        "",
    ]

    low_conf = stats["low_confidence_pages"]
    if low_conf:
        report_lines += [
            "## Pages Requiring Review (non-clean confidence)",
            "",
            "| Page | Confidence |",
            "|------|------------|",
        ]
        for entry in low_conf:
            report_lines.append(f"| {entry['page']} | {entry['confidence']} |")
        report_lines.append("")
    else:
        report_lines += ["## Pages Requiring Review", "", "None — all pages returned clean text.", ""]

    if stats["pages_with_warnings"]:
        report_lines += [
            "## Pages with Warnings",
            "",
            ", ".join(str(p) for p in stats["pages_with_warnings"]),
            "",
        ]
    else:
        report_lines += ["## Pages with Warnings", "", "None.", ""]

    report_path = output_dir / "extraction_report.md"
    report_path.write_text("\n".join(report_lines), encoding="utf-8")

    # --- Summary ---
    print(f"\nExtraction complete.")
    print(f"  Pages: {pages_processed}/{total_pages}")
    print(f"  Text confidence - clean: {stats['clean']}, sparse: {stats['sparse']}, empty: {stats['empty']}")
    print(f"  OCR applied: {stats['ocr_applied']} pages")
    print(f"  Images extracted: {stats['images_extracted']}")
    print(f"  Tables detected: {stats['tables_detected']} ({stats['tables_truncated']} truncated)")
    print(f"  Output size: {total_mb:.1f} MB")
    print(f"  Duration: {elapsed:.1f}s")
    print(f"  JSON: {json_path}")
    print(f"  Report: {report_path}")


if __name__ == "__main__":
    main()
