import json, sys

with open(r"assets\gnc355_pdf_extracted\text_by_page.json", 'r', encoding='utf-8') as f:
    data = json.load(f)

pages = ['75','76','77','78','79','80','81','82','98','283','284','290']
for p in pages:
    if p in data:
        print(f"=== PAGE {p} ===")
        print(data[p][:2000])
        print()
    else:
        print(f"PAGE {p}: NOT FOUND")