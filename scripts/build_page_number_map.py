#!/usr/bin/env python3
"""Build a bidirectional physical-to-logical page number map from LlamaParse extraction.

Reads each page_NNN.md from the LlamaParse extraction directory, parses the
Garmin logical page footer (e.g. "2-42 Pilot's Guide 190-02488-01 Rev. C"),
and writes a bidirectional JSON map.

Usage:
    python scripts/build_page_number_map.py [--pages-dir DIR] [--output PATH]
                                             [--check] [--verify] [--verbose]

Exit codes: 0 on success (all critical verifications pass); 1 otherwise.
"""

import argparse
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

# ── Regex constants ──────────────────────────────────────────────────────────

_APOS = "[" + chr(0x2019) + chr(0x0027) + "]"  # curly or straight apostrophe

# Right-aligned: "190-02488-01 Rev. C    Pilot’s Guide    {id}"
# Also handles bold doc-number variant: "**190-02488-01 Rev. C** Pilot’s Guide {id}"
_FOOTER_RIGHT_RE = re.compile(
    r"(?:\*\*)?190-02488-01\s+Rev\.\s+C(?:\*\*)?\s+Pilot" + _APOS + r"s\s+Guide\s+([A-Za-z0-9][A-Za-z0-9\-]*)\s*$",
    re.MULTILINE,
)

# Left-aligned, plain or **bold**: "{id} Pilot’s Guide 190-02488-01 Rev. C"
_FOOTER_LEFT_RE = re.compile(
    r"(?:\*\*)?([A-Za-z0-9][A-Za-z0-9\-]*)(?:\*\*)?\s+Pilot"
    + _APOS
    + r"s\s+Guide\s+190-02488-01\s+Rev\.\s+C",
    re.MULTILINE,
)

# Narration form (intentionally-blank pages rendered as structured prose):
#   plain:   "-   6-22\n    -   Pilot’s Guide\n    -   190-02488-01 Rev. C"
#   labeled: "-   Page Number: 2-74\n    -   Document Title: Pilot’s Guide"
_FOOTER_NARRATION_RE = re.compile(
    r"-\s+(?:Page Number:\s*)?([A-Za-z0-9][A-Za-z0-9\-]*)\s*\n\s*-\s+(?:Document Title:\s*)?Pilot"
    + _APOS
    + r"s\s+Guide",
    re.MULTILINE,
)

# Description-mode variants where LlamaParse described the page instead of extracting text.
# "**Page Number:** 1-5"  or  "**Page Number:** The page number is 3-45"
_FOOTER_PAGE_INFO_RE = re.compile(
    r"\*\*Page Number:\*\*\s*(?:The page number is\s*)?([A-Za-z0-9][A-Za-z0-9\-]*)",
    re.IGNORECASE,
)

# "### **Page 2-40: Pilot’s Guide 190-02488-01 Rev. C**"
_FOOTER_PAGE_HEADING_RE = re.compile(
    r"\*\*Page\s+([A-Za-z0-9][A-Za-z0-9\-]*):\s+Pilot" + _APOS + r"s\s+Guide",
    re.MULTILINE,
)

# "The page number is 3-45, located at the bottom"
_FOOTER_PROSE_RE = re.compile(
    r"[Tt]he page number is ([A-Za-z0-9][A-Za-z0-9\-]*)",
    re.MULTILINE,
)

# ── Anchor citations from ITM-11 ─────────────────────────────────────────────

ANCHOR_CITATIONS = [
    (80,  "2-42", "XPDR Modes (s11.4 source)"),
    (82,  "2-44", "VFR Key + IDENT (s11.6 source)"),
    (98,  "2-58", "Unit Selections (s4.10 source)"),
    (129, "3-15", "Land Data Symbols (s4.X source)"),
]

_ROMAN_SEQUENCE = [
    "i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x",
    "xi", "xii", "xiii", "xiv",
]  # expected for physical pages 3–16 (front matter)


# ── Helpers ──────────────────────────────────────────────────────────────────

def _tail(text: str, n: int = 20) -> str:
    """Return the last n non-empty lines of text joined by newlines.

    Searching only the tail prevents false positives from body content that
    might contain document-number fragments earlier in the page.
    """
    lines = [ln for ln in text.splitlines() if ln.strip()]
    return "\n".join(lines[-n:])


def parse_footer(page_text: str) -> str | None:
    """Return the Garmin logical page identifier, or None if not parseable.

    Checks patterns in order of reliability:
      1. Right-aligned footer (may have **bold** doc number)
      2. Left-aligned footer, plain or **bold** page id
      3. Narration-form footer (structured list; plain or labeled)
      4. Page Information label: "**Page Number:** {id}"
      5. Page heading: "**Page {id}: Pilot's Guide ..."
      6. Prose description: "The page number is {id}"
    """
    tail = _tail(page_text)

    m = _FOOTER_RIGHT_RE.search(tail)
    if m:
        return m.group(1).strip()

    m = _FOOTER_LEFT_RE.search(tail)
    if m:
        return m.group(1).strip()

    m = _FOOTER_NARRATION_RE.search(tail)
    if m:
        return m.group(1).strip()

    # Description-mode variants: search full text for these (may not be at tail)
    m = _FOOTER_PAGE_INFO_RE.search(page_text)
    if m:
        return m.group(1).strip()

    m = _FOOTER_PAGE_HEADING_RE.search(page_text)
    if m:
        return m.group(1).strip()

    m = _FOOTER_PROSE_RE.search(page_text)
    if m:
        return m.group(1).strip()

    return None


def _classify_format(text: str, tail: str) -> str:
    if _FOOTER_RIGHT_RE.search(tail):
        return "right_aligned"
    m = _FOOTER_LEFT_RE.search(tail)
    if m:
        return "bold_variant" if "**" in m.group(0) else "left_aligned"
    if _FOOTER_NARRATION_RE.search(tail):
        return "narration"
    if _FOOTER_PAGE_INFO_RE.search(text):
        return "page_info_label"
    if _FOOTER_PAGE_HEADING_RE.search(text):
        return "page_heading"
    if _FOOTER_PROSE_RE.search(text):
        return "prose_description"
    return "unparseable"


# ── Map building ─────────────────────────────────────────────────────────────

def build_map(pages_dir: Path, verbose: bool = False) -> dict:
    """Parse all page_NNN.md files and return raw mapping data."""
    page_files = sorted(pages_dir.glob("page_*.md"))

    physical_to_logical: dict[str, str] = {}
    logical_to_physical: dict[str, int] = {}
    logical_duplicates: list[dict] = []
    unparseable_pages: list[int] = []
    format_counts: dict[str, int] = {
        "right_aligned": 0,
        "left_aligned": 0,
        "bold_variant": 0,
        "narration": 0,
        "page_info_label": 0,
        "page_heading": 0,
        "prose_description": 0,
        "unparseable": 0,
    }
    parsed_count = 0

    for page_file in page_files:
        phys_num = int(page_file.stem.split("_")[1])
        text = page_file.read_text(encoding="utf-8")
        tail = _tail(text)
        fmt = _classify_format(text, tail)
        ident = parse_footer(text)

        format_counts[fmt] += 1

        if verbose:
            print(f"  page_{phys_num:03d}: fmt={fmt:<14s}  ident={ident!r}")

        if ident:
            parsed_count += 1
            physical_to_logical[str(phys_num)] = ident
            if ident in logical_to_physical:
                existing = logical_to_physical[ident]
                print(f"WARNING: duplicate logical '{ident}' at physical {existing} and {phys_num}")
                found = next((d for d in logical_duplicates if d["logical"] == ident), None)
                if found:
                    found["physical_pages"].append(phys_num)
                else:
                    logical_duplicates.append({"logical": ident, "physical_pages": [existing, phys_num]})
            else:
                logical_to_physical[ident] = phys_num
        else:
            physical_to_logical[str(phys_num)] = "unparseable"
            unparseable_pages.append(phys_num)

    return {
        "parsed_count": parsed_count,
        "physical_to_logical": physical_to_logical,
        "logical_to_physical": logical_to_physical,
        "logical_duplicates": logical_duplicates,
        "unparseable_pages": unparseable_pages,
        "format_counts": format_counts,
    }


# ── Verification ─────────────────────────────────────────────────────────────

def run_verification(result: dict) -> bool:
    """Print V1–V7 checks. Returns True iff V1+V2+V3+V6 all pass."""
    p2l = result["physical_to_logical"]
    parsed = result["parsed_count"]
    unparseable = result["unparseable_pages"]
    total = parsed + len(unparseable)
    critical_pass = True

    # V1 — page count
    v1 = total == 330
    print(f"\nV1 [physical_page_count == 330]: {'PASS' if v1 else 'FAIL'} (got {total})")
    if not v1:
        critical_pass = False

    # V2 — coverage
    v2 = (parsed + len(unparseable)) == 330
    print(
        f"V2 [parsed + unparseable == 330]: {'PASS' if v2 else 'FAIL'} "
        f"({parsed} + {len(unparseable)} = {total})"
    )
    if not v2:
        critical_pass = False

    # V3 — anchor citations
    print("\nV3 [Anchor citations - ITM-11]:")
    v3_pass = 0
    for phys, expected, label in ANCHOR_CITATIONS:
        actual = p2l.get(str(phys), "MISSING")
        ok = actual == expected
        if ok:
            v3_pass += 1
        print(
            f"  {'PASS' if ok else 'FAIL'}: {label} - "
            f"physical {phys} -> '{actual}' (expected '{expected}')"
        )
    print(f"  V3 summary: {v3_pass}/{len(ANCHOR_CITATIONS)} PASS")
    if v3_pass < len(ANCHOR_CITATIONS):
        critical_pass = False

    # V4 — roman numerals for pages 3–16 (advisory)
    print("\nV4 [Roman numeral pages 3-16] (advisory):")
    actual_romans = []
    for p in range(3, 17):
        ident = p2l.get(str(p), "MISSING")
        actual_romans.append(ident)
        print(f"  page_{p:03d}: '{ident}'")
    v4 = actual_romans == _ROMAN_SEQUENCE
    print(f"  V4: {'PASS' if v4 else 'ADVISORY - sequence differs from expected i..xiv'}")
    if not v4:
        print(f"  Expected: {_ROMAN_SEQUENCE}")
        print(f"  Got:      {actual_romans}")

    # V5 — section transitions (advisory)
    print("\nV5 [Section transitions] (advisory):")

    def numeric_section(ident: str | None) -> int | None:
        if not ident or ident in ("unparseable", "MISSING"):
            return None
        parts = ident.split("-")
        if len(parts) == 2:
            try:
                return int(parts[0])
            except ValueError:
                return None
        return None

    transitions = 0
    prev_phys: int | None = None
    prev_ident: str | None = None
    for p in range(1, 331):
        ident = p2l.get(str(p))
        if ident and ident != "unparseable":
            ps = numeric_section(prev_ident)
            cs = numeric_section(ident)
            if ps is not None and cs is not None and cs != ps:
                print(f"  physical {prev_phys}->{p}: {prev_ident}->{ident} (section {ps}->{cs})")
                transitions += 1
            prev_phys, prev_ident = p, ident
    print(f"  V5: {transitions} section transitions detected")

    # V6 — logical duplicates
    dups = result["logical_duplicates"]
    v6 = len(dups) == 0
    print(f"\nV6 [Logical duplicates]: {'PASS' if v6 else 'FAIL'} ({len(dups)} duplicates)")
    for d in dups:
        print(f"  '{d['logical']}' at physical pages {d['physical_pages']}")
    if not v6:
        critical_pass = False

    # V7 — unparseable inventory
    print(f"\nV7 [Unparseable pages]: {len(unparseable)} total")
    v7_ok = len(unparseable) <= 30
    print(f"  {'OK' if v7_ok else 'FAIL - >30 pages unparseable; parser may be broken'}")
    for p in unparseable:
        print(f"  page_{p:03d}")

    return critical_pass


# ── Main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    # Ensure UTF-8 output even when terminal encoding is narrow (e.g., cp1252 on Windows)
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")

    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--pages-dir",
        default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/pages",
        help="Directory containing page_NNN.md files",
    )
    ap.add_argument(
        "--output",
        default="assets/gnc355_pdf_extracted/llamaparse_agentic_v1/page_number_map.json",
        help="JSON output path",
    )
    ap.add_argument("--check", action="store_true", help="Verify in memory; do NOT write JSON output")
    ap.add_argument("--verify", action="store_true", help="Run anchor-citation verification after producing map")
    ap.add_argument("--verbose", action="store_true", help="Print per-page parse results")
    args = ap.parse_args()

    pages_dir = Path(args.pages_dir)
    if not pages_dir.exists():
        print(f"ERROR: pages directory not found: {pages_dir}", file=sys.stderr)
        sys.exit(1)

    page_files = list(pages_dir.glob("page_*.md"))
    print(f"Found {len(page_files)} page files in {pages_dir}")

    if args.verbose:
        print("\nPer-page parse results:")

    result = build_map(pages_dir, verbose=args.verbose)

    parsed = result["parsed_count"]
    unparseable = result["unparseable_pages"]
    print(f"\nSummary: {parsed} parsed, {len(unparseable)} unparseable, {parsed + len(unparseable)} total")

    map_data: dict = {
        "metadata": {
            "source_pdf": "190-02488-01_Pilots_Guide_Rev_C.pdf",
            "extraction_dir": "assets/gnc355_pdf_extracted/llamaparse_agentic_v1",
            "physical_page_count": parsed + len(unparseable),
            "parsed_count": parsed,
            "unparseable_count": len(unparseable),
            "generated": datetime.now(timezone.utc).isoformat(),
        },
        "physical_to_logical": result["physical_to_logical"],
        "logical_to_physical": result["logical_to_physical"],
        "logical_duplicates": result["logical_duplicates"],
        "unparseable_pages": unparseable,
    }

    all_critical_pass = True
    if args.verify or args.check:
        all_critical_pass = run_verification(result)

    if not args.check:
        output_path = Path(args.output)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        json_text = json.dumps(map_data, indent=2, ensure_ascii=False) + "\n"
        output_path.write_text(json_text, encoding="utf-8")
        bytes_written = len(json_text.encode("utf-8"))
        print(f"\nWrote {bytes_written:,} bytes to {output_path}")

    sys.exit(0 if all_critical_pass else 1)


if __name__ == "__main__":
    main()
