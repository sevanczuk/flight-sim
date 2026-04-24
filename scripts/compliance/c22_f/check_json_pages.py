import json

with open(r"assets\gnc355_pdf_extracted\text_by_page.json", 'r', encoding='utf-8') as f:
    data = json.load(f)

pages = data['pages']
print(f"pages type: {type(pages)}")
if isinstance(pages, dict):
    keys = list(pages.keys())
    print(f"Total page keys: {len(keys)}")
    print(f"First 5 keys: {keys[:5]}")
    print(f"Sample key types: {[type(k).__name__ for k in keys[:3]]}")
    # Check for pages we need
    for p in ['75', 75, '283', 283, '290', 290]:
        if p in pages:
            print(f"\nFound '{p}' in pages:")
            print(str(pages[p])[:300])
elif isinstance(pages, list):
    print(f"pages list length: {len(pages)}")
    print(f"First item: {pages[0] if pages else 'empty'}")
    # find page 75
    for i, p in enumerate(pages):
        if isinstance(p, dict) and ('page' in p or 'page_num' in p or 'number' in p):
            pnum = p.get('page', p.get('page_num', p.get('number')))
            if pnum in [75, '75']:
                print(f"Found page 75 at index {i}: {str(p)[:300]}")
                break
    print(f"\nFirst 2 items (structure):")
    for item in pages[:2]:
        if isinstance(item, dict):
            print(f"  Keys: {list(item.keys())}")
            print(f"  Values preview: {str(item)[:200]}")