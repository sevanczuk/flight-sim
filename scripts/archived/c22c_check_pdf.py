"""S12-S15: PDF verification for Fragment C compliance checks."""
import json

PDF_JSON = "assets/gnc355_pdf_extracted/text_by_page.json"

with open(PDF_JSON, encoding="utf-8") as f:
    raw = json.load(f)

# Build page_num -> text dict
pages = {}
for entry in raw.get("pages", []):
    pn = entry.get("page_number")
    text = entry.get("text", "") or ""
    pages[pn] = text

def page_text(n):
    return pages.get(n, "")

def found_in_range(terms, start, end):
    results = {}
    for p in range(start, end + 1):
        t = page_text(p)
        for term in terms:
            if term in t:
                results.setdefault(term, []).append(p)
    return results

print("=== S12: GPS Flight Phase Annunciations (pp. 184-185) ===")
annunciations = ["OCEANS", "ENRT", "TERM", "DPRT", "LNAV/VNAV", "LNAV+V", "LNAV", "LP+V", "LP", "LPV", "MAPR"]
for p in [184, 185]:
    t = page_text(p)
    print(f"\n--- Page {p} ({len(t)} chars) ---")
    for ann in annunciations:
        print(f"  {ann}: {'FOUND' if ann in t else 'NOT FOUND'}")

print("\n\n=== S13: FIS-B Weather Products (pp. 230-243) ===")
search_terms = [
    ("NEXRAD",           ["NEXRAD"]),
    ("METARs",           ["METAR"]),
    ("TAFs",             ["TAF"]),
    ("Graphical AIRMETs",["AIRMET", "G-AIRMET", "Graphical AIRMET"]),
    ("SIGMETs",          ["SIGMET"]),
    ("PIREPs",           ["PIREP"]),
    ("Cloud Tops",       ["Cloud Tops", "Cloud Top"]),
    ("Lightning",        ["Lightning"]),
    ("CWA",              ["CWA", "Center Weather"]),
    ("Winds/Temps Aloft",["Winds Aloft", "Winds/Temps", "Wind"]),
    ("Icing",            ["Icing"]),
    ("Turbulence",       ["Turbulence"]),
    ("TFRs",             ["TFR"]),
]
for label, terms in search_terms:
    hits = {}
    for p in range(230, 244):
        t = page_text(p)
        for term in terms:
            if term in t:
                hits.setdefault(term, []).append(p)
    if hits:
        print(f"  {label}: FOUND (terms {list(hits.keys())}) on page(s) {sorted({p for pp in hits.values() for p in pp})}")
    else:
        print(f"  {label}: NOT FOUND in pp. 230-243")

print("\n--- Product Status States (p. 231) ---")
t231 = page_text(231)
print(f"Page 231 chars: {len(t231)}")
for state in ["Unavailable", "Awaiting Data", "Data Available"]:
    print(f"  '{state}': {'FOUND' if state in t231 else 'NOT FOUND'}")

print("\n\n=== S14: Approach Types (pp. 199-206) ===")
approach_terms = [
    ("LNAV",      ["LNAV"]),
    ("LNAV/VNAV", ["LNAV/VNAV"]),
    ("LNAV+V",    ["LNAV+V"]),
    ("LPV",       ["LPV"]),
    ("LP",        ["LP"]),
    ("LP+V",      ["LP+V"]),
    ("ILS",       ["ILS"]),
]
for label, terms in approach_terms:
    hits = []
    for p in range(199, 207):
        t = page_text(p)
        for term in terms:
            if term in t:
                hits.append(p)
                break
    if hits:
        print(f"  {label}: FOUND on page(s) {sorted(set(hits))}")
    else:
        print(f"  {label}: NOT FOUND in pp. 199-206")
        # Broaden search for LP without triggering LNAV matches
        if label == "LP":
            for p in range(199, 207):
                t = page_text(p)
                if p == 199:
                    print(f"    Sample p.199 (100 chars): {repr(t[:100])}")

print("\n\n=== S15: ADS-B Status AIRB/SURF/ATAS (pp. 107-108) ===")
for p in [107, 108]:
    t = page_text(p)
    print(f"Page {p} ({len(t)} chars)")
    for term in ["AIRB", "SURF", "ATAS"]:
        print(f"  {term}: {'FOUND' if term in t else 'NOT FOUND'}")
    # Show first 200 chars for context
    if t:
        print(f"  Sample: {repr(t[:200])}")

# Broader search for AIRB/SURF/ATAS
print("\nBroader search for AIRB/SURF/ATAS across all pages:")
for term in ["AIRB", "SURF", "ATAS"]:
    found_pages = [pn for pn, t in pages.items() if term in t]
    print(f"  {term}: pages {sorted(found_pages)[:10] if found_pages else 'NONE'}")
