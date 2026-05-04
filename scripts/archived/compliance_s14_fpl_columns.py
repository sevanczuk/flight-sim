"""S14: Verify FPL data columns (CUM, DIS, DTK, ESA, ETA, ETE) and defaults in PDF p. 149."""
import json

with open("assets/gnc355_pdf_extracted/text_by_page.json", encoding="utf-8") as f:
    data = json.load(f)

pages = data["pages"]
target = next((p for p in pages if p["page_number"] == 149), None)
page_text = target["text"] if target else ""

print("=== PDF page 149 text ===")
print(page_text)

print("\n=== Column code search ===")
columns = ["CUM", "DIS", "DTK", "ESA", "ETA", "ETE"]
for col in columns:
    print(f"'{col}': {'FOUND' if col in page_text else 'NOT FOUND'}")

print("\n=== Default context search ===")
for term in ["Column 1", "Column 2", "Column 3", "default", "Default", "DTK", "DIS", "CUM"]:
    print(f"'{term}': {'FOUND' if term in page_text else 'NOT FOUND'}")
