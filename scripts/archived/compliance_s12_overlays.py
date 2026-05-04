"""S12: Verify map overlays (Lightning, METAR, Airways, Obstacles) in PDF pp. 116-139."""
import json

with open("assets/gnc355_pdf_extracted/text_by_page.json", encoding="utf-8") as f:
    data = json.load(f)

pages = data["pages"]
target = [p for p in pages if 116 <= p["page_number"] <= 139]
extras = ["Lightning", "METAR", "Airways", "Obstacles"]

for extra in extras:
    found_pages = [p["page_number"] for p in target if extra.lower() in p["text"].lower()]
    if found_pages:
        print(f"FOUND '{extra}' on pages: {found_pages}")
    else:
        print(f"NOT FOUND '{extra}' in pp. 116-139")
