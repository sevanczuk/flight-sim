import json, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

with open('assets/gnc355_pdf_extracted/text_by_page.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

pages = data['pages']

def get_page(n):
    # pages list is 0-indexed; page numbers are 1-based
    for p in pages:
        if isinstance(p, dict):
            pn = p.get('page_number')
            if pn == n:
                return p.get('text', '')
        elif isinstance(p, str):
            parsed = eval(p)  # fallback if stringified
            if parsed.get('page_number') == n:
                return parsed.get('text', '')
    return ''

def get_pages_range(start, end):
    texts = []
    for n in range(start, end + 1):
        t = get_page(n)
        if t:
            texts.append(f'--- p.{n} ---\n{t}')
    return '\n'.join(texts)

checks = [
    {
        'id': 1,
        'claim': 'SD card: FAT32, 8-32 GB',
        'section': '§2.2',
        'pages': [22],
        'phrases': ['FAT32', '8', '32', 'GB'],
    },
    {
        'id': 2,
        'claim': 'Inner knob push = Direct-to (GPS 175/GNX 375)',
        'section': '§2.5, §2.7',
        'pages': list(range(27, 31)),
        'phrases': ['Direct-to', 'inner', 'push'],
    },
    {
        'id': 3,
        'claim': 'Power-off: hold Power/Home key ≥0.5 s',
        'section': '§3.4',
        'pages': [38, 39],
        'phrases': ['0.5', 'Power', 'Home', 'hold'],
    },
    {
        'id': 4,
        'claim': 'Database types: Navigation, Obstacles, SafeTaxi, Basemap, Terrain with expiry flags',
        'section': '§3.5',
        'pages': [40],
        'phrases': ['Navigation', 'Obstacles', 'SafeTaxi', 'Basemap', 'Terrain'],
    },
    {
        'id': 5,
        'claim': 'Color conventions include gray and blue',
        'section': '§2.9',
        'pages': [32],
        'phrases': ['Gray', 'Blue', 'gray', 'blue'],
    },
]

print('=== Category 2: PDF Page Reference Spot Checks ===\n')

for c in checks:
    combined_text = ''
    for pn in c['pages']:
        combined_text += get_page(pn) + ' '
    combined_text_lower = combined_text.lower()

    missing = [p for p in c['phrases'] if p.lower() not in combined_text_lower]
    if missing:
        status = 'DISCREPANCY'
        note = f'Missing phrases: {missing}'
    else:
        status = 'CONFIRMED'
        note = 'All key phrases found'

    print(f'Check {c["id"]}: {c["claim"]}')
    print(f'  Pages checked: {c["pages"]}')
    print(f'  Status: {status}')
    print(f'  Note: {note}')

    # Print snippet for context
    if combined_text.strip():
        preview = combined_text.strip()[:300].replace('\n', ' ')
        print(f'  PDF text preview: {preview}')
    else:
        print(f'  PDF text: [EMPTY - pages may be sparse]')
    print()

print('\n=== Category 2: Unexpected Content Additions (Check 6) ===\n')

extra_checks = [
    {
        'id': '6a',
        'claim': '§1.1: GNC 355 has TSO-C169a VHF COM',
        'pages': list(range(18, 21)),
        'phrases': ['TSO-C169', 'COM'],
    },
    {
        'id': '6b',
        'claim': '§2.2: SD card insertion/ejection: label facing left, spring latch',
        'pages': [22],
        'phrases': ['label', 'spring', 'latch', 'left'],
    },
    {
        'id': '6c',
        'claim': '§2.8: Screenshot: push-hold inner knob + Home/Power; camera icon in annunciator bar',
        'pages': [31],
        'phrases': ['camera', 'inner', 'Home', 'annunciator'],
    },
    {
        'id': '6d',
        'claim': '§2.9: Gray and Blue color entries beyond outline 6 colors',
        'pages': [32],
        'phrases': ['Gray', 'Blue', 'gray', 'blue'],
    },
    {
        'id': '6e',
        'claim': '§3.5: DB SYNC product list: GI 275, GDU TXi v3.10+, GTN v6.72, GTN Xi v20.20+',
        'pages': list(range(40, 53)),
        'phrases': ['GI 275', 'GDU TXi', 'GTN'],
    },
]

for c in extra_checks:
    combined_text = ''
    for pn in c['pages']:
        combined_text += get_page(pn) + ' '
    combined_text_lower = combined_text.lower()

    missing = [p for p in c['phrases'] if p.lower() not in combined_text_lower]
    if missing:
        status = 'DISCREPANCY'
        note = f'Phrases not found in PDF pages {c["pages"]}: {missing}'
    else:
        status = 'CONFIRMED'
        note = 'All key phrases found in PDF'

    print(f'Check {c["id"]}: {c["claim"]}')
    print(f'  Pages checked: {c["pages"]}')
    print(f'  Status: {status}')
    print(f'  Note: {note}')
    if combined_text.strip():
        preview = combined_text.strip()[:300].replace('\n', ' ')
        print(f'  PDF text preview: {preview}')
    else:
        print(f'  PDF text: [EMPTY]')
    print()
