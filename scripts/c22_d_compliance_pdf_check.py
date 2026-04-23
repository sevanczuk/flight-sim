"""
C2.2-D Compliance PDF spot checks: S18 (HAL table p.88), S19 (Parallel Track pp.147-148),
S20 (Waypoint Options pp.152-153), plus F11 ITM-08 re-grep of Fragment A Appendix B.
"""

import json
import re
import sys

PDF_JSON = "assets/gnc355_pdf_extracted/text_by_page.json"
FRAGMENT_A = "docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md"


def load_pages(path: str) -> dict:
    with open(path, encoding="utf-8") as f:
        d = json.load(f)
    # pages is a list of dicts with 'page_number' key
    pages_list = d["pages"]
    return {p["page_number"]: p for p in pages_list}


def get_page(pages: dict, page_num: int) -> str:
    """Return text for a page number."""
    entry = pages.get(page_num, {})
    return entry.get("text", "")


# ---------------------------------------------------------------------------
# S18 — HAL table PDF p. 88
# ---------------------------------------------------------------------------
def check_s18(pages: dict) -> None:
    print("=" * 60)
    print("S18: HAL table — PDF p. 88")
    text = get_page(pages, 88)
    if not text:
        print("  ERROR: no text extracted for p. 88")
        return
    print(f"  Page 88 char count: {len(text)}")
    # Print the full page text for manual inspection
    print("  --- page 88 text (first 1500 chars) ---")
    print(text[:1500])
    # Search for HAL values
    hal_pattern = re.compile(r'(?:HAL|Horizontal Alarm Limit|alarm limit|CDI scale|0\.30|1\.00|2\.00)', re.IGNORECASE)
    matches = hal_pattern.findall(text)
    print(f"\n  HAL/scale-related matches: {matches}")
    # Specific flight phase and value pairs
    phase_patterns = [
        ("Approach / 0.30 nm", re.compile(r'[Aa]pproach.{0,60}0\.30', re.DOTALL)),
        ("Terminal / 1.00 nm", re.compile(r'[Tt]erminal.{0,60}1\.00', re.DOTALL)),
        ("En Route / 2.00 nm", re.compile(r'(?:En [Rr]oute|Enroute).{0,60}2\.00', re.DOTALL)),
        ("Oceanic / 2.00 nm", re.compile(r'[Oo]ceanic.{0,60}2\.00', re.DOTALL)),
    ]
    for label, pat in phase_patterns:
        m = pat.search(text)
        print(f"  {label}: {'FOUND' if m else 'NOT FOUND'}")


# ---------------------------------------------------------------------------
# S19 — Parallel Track pp. 147-148
# ---------------------------------------------------------------------------
def check_s19(pages: dict) -> None:
    print("=" * 60)
    print("S19: Parallel Track offset range — PDF pp. 147–148")
    text = get_page(pages, 147) + "\n" + get_page(pages, 148)
    if not text.strip():
        print("  ERROR: no text extracted for pp. 147-148")
        return
    print(f"  Pages 147+148 combined char count: {len(text)}")
    print("  --- pp. 147-148 text (first 2000 chars) ---")
    print(text[:2000])
    # Search for offset range
    range_patterns = [
        ("1-99 nm", re.compile(r'1\s*[-–—]\s*99\s*(?:nm|nautical)', re.IGNORECASE)),
        ("99 nm", re.compile(r'99\s*(?:nm|nautical)', re.IGNORECASE)),
        ("offset", re.compile(r'offset', re.IGNORECASE)),
        ("parallel track", re.compile(r'parallel\s+track', re.IGNORECASE)),
    ]
    for label, pat in range_patterns:
        m = pat.search(text)
        print(f"  '{label}': {'FOUND' if m else 'NOT FOUND'}")


# ---------------------------------------------------------------------------
# S20 — Waypoint Options pp. 152-153
# ---------------------------------------------------------------------------
def check_s20(pages: dict) -> None:
    print("=" * 60)
    print("S20: Waypoint Options menu — PDF pp. 152–153")
    text = get_page(pages, 152) + "\n" + get_page(pages, 153)
    if not text.strip():
        print("  ERROR: no text extracted for pp. 152-153")
        return
    print(f"  Pages 152+153 combined char count: {len(text)}")
    print("  --- pp. 152-153 text (first 2500 chars) ---")
    print(text[:2500])
    # Check 8 claimed options
    options = [
        "Insert Before",
        "Insert After",
        "Load PROC",
        "Load Airway",
        "Activate Leg",
        "Hold at WPT",
        "WPT Info",
        "Remove",
    ]
    print("\n  Waypoint Options menu item check:")
    for opt in options:
        found = opt.lower() in text.lower()
        print(f"    {opt}: {'FOUND' if found else 'NOT FOUND'}")


# ---------------------------------------------------------------------------
# F11 — ITM-08 re-grep Fragment A Appendix B
# ---------------------------------------------------------------------------
TERMS_25 = [
    "FAF", "MAP", "LPV", "LNAV", "SBAS", "WAAS", "TSAA", "FIS-B", "UAT",
    "1090 ES", "Extended Squitter", "TSO-C112e", "TSO-C166b", "WOW", "IDENT",
    "Flight ID", "GPSS", "VDI", "CDI", "OBS", "RAIM", "VCALC", "DTK", "ETE",
    "XTK", "XPDR",
]

TERMS_EXCLUDED = ["EPU", "HFOM/VFOM", "HDOP", "TSO-C151c"]


def check_f11(fragment_a_path: str) -> None:
    print("=" * 60)
    print("F11: ITM-08 re-grep — Fragment A Appendix B")

    with open(fragment_a_path, encoding="utf-8") as f:
        lines = f.readlines()

    # Find Appendix B section
    appb_start = None
    appb_end = None
    for i, line in enumerate(lines):
        if "## Appendix B:" in line:
            appb_start = i
        elif appb_start is not None and line.startswith("## ") and "Appendix B" not in line:
            appb_end = i
            break
    if appb_start is None:
        print("  ERROR: Appendix B section not found in Fragment A")
        return
    if appb_end is None:
        appb_end = len(lines)

    appb_text = "".join(lines[appb_start:appb_end])
    print(f"  Appendix B: lines {appb_start+1}–{appb_end} ({appb_end - appb_start} lines)")

    print("\n  25-term check:")
    missing = []
    for term in TERMS_25:
        # Match term as whole word or as table entry
        pattern = re.compile(r'\b' + re.escape(term) + r'\b', re.IGNORECASE)
        match = pattern.search(appb_text)
        # Find first matching line number
        line_num = None
        for i, line in enumerate(lines[appb_start:appb_end]):
            if pattern.search(line):
                line_num = appb_start + i + 1
                break
        status = f"FOUND (line {line_num})" if match else "NOT FOUND"
        print(f"    {term:<22}: {status}")
        if not match:
            missing.append(term)

    if missing:
        print(f"\n  FAIL — terms NOT found in Appendix B: {missing}")
    else:
        print("\n  PASS — all 25 terms confirmed present in Appendix B")

    print("\n  Excluded-terms check (should NOT appear in Fragment D Coupling Summary claims):")
    with open("docs/specs/fragments/GNX375_Functional_Spec_V1_part_D.md", encoding="utf-8") as f:
        frag_d = f.read()
    # Find Coupling Summary block
    cs_start = frag_d.find("## Coupling Summary")
    cs_text = frag_d[cs_start:] if cs_start >= 0 else ""
    for term in TERMS_EXCLUDED:
        claimed = term in cs_text and "NOT claimed" not in cs_text[max(0, cs_text.find(term) - 30):cs_text.find(term) + 30]
        in_cs = term in cs_text
        print(f"    {term:<14}: in Coupling Summary = {in_cs} (as excluded = expected)")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    try:
        pages = load_pages(PDF_JSON)
    except Exception as e:
        print(f"ERROR loading PDF JSON: {e}")
        sys.exit(1)

    check_s18(pages)
    check_s19(pages)
    check_s20(pages)
    check_f11(FRAGMENT_A)


if __name__ == "__main__":
    main()
