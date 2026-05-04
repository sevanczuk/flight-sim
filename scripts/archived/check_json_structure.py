import json

with open(r"assets\gnc355_pdf_extracted\text_by_page.json", 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"Type: {type(data)}")
if isinstance(data, dict):
    keys = list(data.keys())
    print(f"Total keys: {len(keys)}")
    print(f"First 10 keys: {keys[:10]}")
    print(f"Last 5 keys: {keys[-5:]}")
    # Check if 75, 283, 290 exist in different forms
    for test in ['75', 75, 'page_75', 'p75', '074', '000075']:
        if test in data:
            print(f"Found key: {repr(test)}")
elif isinstance(data, list):
    print(f"List length: {len(data)}")
    print(f"First item keys: {list(data[0].keys()) if data else 'empty'}")
    # look for page 75
    for item in data[:5]:
        print(item)