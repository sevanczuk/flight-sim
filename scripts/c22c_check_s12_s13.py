"""S12/S13: Verify GPS Flight Phase Annunciations (pp. 184-185) and FIS-B products (pp. 230-243)."""
import json
import sys

PDF_JSON = "assets/gnc355_pdf_extracted/text_by_page.json"

with open(PDF_JSON, encoding="utf-8") as f:
    pages = json.load(f)

def get_page_text(page_num):
    key = str(page_num)
    entry = pages.get(key, {})
    if isinstance(entry, dict):
        return entry.get("text", "") or entry.get("content", "") or str(entry)
    return str(entry)

# S12: GPS Flight Phase Annunciations pp. 184-185
print("=== S12: GPS Flight Phase Annunciations (pp. 184-185) ===")
annunciations = ["OCEANS", "ENRT", "TERM", "DPRT", "LNAV/VNAV", "LNAV+V", "LNAV", "LP+V", "LP", "LPV", "MAPR"]
for p in [184, 185]:
    text = get_page_text(p)
    print(f"\n--- Page {p} (chars: {len(text)}) ---")
    for ann in annunciations:
        found = ann in text
        print(f"  {ann}: {'FOUND' if found else 'NOT FOUND'}")

print("\n\n=== S13: FIS-B Weather Products (pp. 230-243) ===")
products = [
    "NEXRAD", "METARs", "METAR", "TAFs", "TAF",
    "Graphical AIRMET", "AIRMET", "SIGMET", "PIREP",
    "Cloud Tops", "Lightning", "CWA", "Winds", "Icing",
    "Turbulence", "TFR"
]
product_labels = [
    "NEXRAD", "METARs", "TAFs", "Graphical AIRMETs", "SIGMETs",
    "PIREPs", "Cloud Tops", "Lightning", "CWA",
    "Winds/Temps Aloft", "Icing", "Turbulence", "TFRs"
]
search_terms = [
    ("NEXRAD", ["NEXRAD"]),
    ("METARs", ["METAR"]),
    ("TAFs", ["TAF"]),
    ("Graphical AIRMETs", ["AIRMET", "G-AIRMET", "Graphical AIRMET"]),
    ("SIGMETs", ["SIGMET"]),
    ("PIREPs", ["PIREP"]),
    ("Cloud Tops", ["Cloud Tops", "Cloud Top"]),
    ("Lightning", ["Lightning"]),
    ("CWA", ["CWA", "Center Weather"]),
    ("Winds/Temps Aloft", ["Winds", "Wind"]),
    ("Icing", ["Icing"]),
    ("Turbulence", ["Turbulence"]),
    ("TFRs", ["TFR"]),
]

all_text_230_243 = ""
page_hits = {}
for p in range(230, 244):
    t = get_page_text(p)
    all_text_230_243 += t
    page_hits[p] = t

for label, terms in search_terms:
    found_pages = [p for p in range(230, 244) if any(t in page_hits[p] for t in terms)]
    if found_pages:
        print(f"  {label}: FOUND on page(s) {found_pages}")
    else:
        print(f"  {label}: NOT FOUND in pp. 230-243")

# Product status states p. 231
print("\n--- Product Status States (p. 231) ---")
text_231 = get_page_text(231)
for state in ["Unavailable", "Awaiting Data", "Data Available"]:
    print(f"  '{state}': {'FOUND' if state in text_231 else 'NOT FOUND'} on p.231")
