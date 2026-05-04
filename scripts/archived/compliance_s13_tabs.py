"""S13: Verify search tab names in PDF pp. 169-171."""
import json

with open("assets/gnc355_pdf_extracted/text_by_page.json", encoding="utf-8") as f:
    data = json.load(f)

pages = data["pages"]
target = [p for p in pages if 169 <= p["page_number"] <= 171]
combined = "\n".join(p["text"] for p in target)

print("=== Combined text of pp. 169-171 ===")
print(combined[:4000])

tabs = ["Recent", "Nearest", "Flight Plan", "User", "Search by Name", "Search by City", "Search by Facility Name"]
print("\n=== Tab search results ===")
for tab in tabs:
    found_pages = [p["page_number"] for p in target if tab.lower() in p["text"].lower()]
    print(f"'{tab}': {'FOUND on pages ' + str(found_pages) if found_pages else 'NOT FOUND'}")
