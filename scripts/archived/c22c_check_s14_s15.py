"""S14/S15: Verify approach types (pp. 199-206) and ADS-B Status sub-pages (pp. 107-108)."""
import json

PDF_JSON = "assets/gnc355_pdf_extracted/text_by_page.json"

with open(PDF_JSON, encoding="utf-8") as f:
    pages = json.load(f)

def get_page_text(page_num):
    key = str(page_num)
    entry = pages.get(key, {})
    if isinstance(entry, dict):
        return entry.get("text", "") or entry.get("content", "") or str(entry)
    return str(entry)

# S14: Approach types pp. 199-206
print("=== S14: Approach Types (pp. 199-206) ===")
approach_terms = [
    ("LNAV", ["LNAV"]),
    ("LNAV/VNAV", ["LNAV/VNAV"]),
    ("LNAV+V", ["LNAV+V"]),
    ("LPV", ["LPV"]),
    ("LP", ["LP"]),
    ("LP+V", ["LP+V"]),
    ("ILS", ["ILS"]),
]
page_texts = {p: get_page_text(p) for p in range(199, 207)}
for label, terms in approach_terms:
    found_pages = [p for p in range(199, 207) if any(t in page_texts[p] for t in terms)]
    if found_pages:
        print(f"  {label}: FOUND on page(s) {found_pages}")
    else:
        print(f"  {label}: NOT FOUND in pp. 199-206")

# S15: ADS-B Status sub-pages pp. 107-108
print("\n=== S15: ADS-B Status AIRB/SURF/ATAS (pp. 107-108) ===")
page_107 = get_page_text(107)
page_108 = get_page_text(108)
combined = page_107 + page_108
print(f"Page 107 chars: {len(page_107)}, Page 108 chars: {len(page_108)}")
for term in ["AIRB", "SURF", "ATAS"]:
    p107 = term in page_107
    p108 = term in page_108
    if p107 or p108:
        pages_found = [p for p, found in [(107, p107), (108, p108)] if found]
        print(f"  {term}: FOUND on page(s) {pages_found}")
    else:
        print(f"  {term}: NOT FOUND on pp. 107-108")
        # Search broader
        found_other = [k for k, v in pages.items() if isinstance(v, dict) and term in (v.get("text","") or v.get("content",""))]
        if found_other:
            print(f"    -> Found '{term}' on pages: {sorted(found_other, key=int)[:5]}")
