import json

with open(r"assets\gnc355_pdf_extracted\text_by_page.json", 'r', encoding='utf-8') as f:
    data = json.load(f)

pages = data['pages']
# Build lookup by page_number
page_lookup = {p['page_number']: p for p in pages}

target_pages = [75, 76, 77, 78, 79, 80, 81, 82, 98, 283, 284, 290]
for pnum in target_pages:
    if pnum in page_lookup:
        p = page_lookup[pnum]
        print(f"=== PAGE {pnum} (confidence: {p['text_confidence']}) ===")
        print(p['text'][:2500])
        print()
    else:
        print(f"PAGE {pnum}: NOT FOUND")
        print()