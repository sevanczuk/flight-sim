import json, sys

with open("assets/gnc355_pdf_extracted/text_by_page.json", "r", encoding="utf-8") as f:
    data = json.load(f)

pages = data if isinstance(data, list) else data.get("pages", [])
total = len(pages)
print(f"Total pages in JSON: {total}")

# Key pages to check (1-indexed in prompt)
check_pages = {
    86: "Pilot Settings",
    89: "CDI On Screen",
    107: "ADS-B Status",
    181: "Procedures overview",
    205: "Visual Approach",
    225: "FIS-B framing",
    245: "Traffic framing",
    257: "Terrain overview",
}

ok = True
for pg_num, label in sorted(check_pages.items()):
    idx = pg_num - 1  # 0-indexed
    if idx >= total:
        print(f"  p.{pg_num} ({label}): OUT OF RANGE (total={total})")
        ok = False
        continue
    
    entry = pages[idx]
    # Handle multiple formats
    if isinstance(entry, dict):
        text = entry.get("text", entry.get("content", ""))
    else:
        text = str(entry)
    
    char_count = len(text)
    status = "OK" if char_count > 100 else "SPARSE"
    print(f"  p.{pg_num} ({label}): {char_count} chars [{status}]")
    if char_count <= 100:
        ok = False

print()
print("Integrity check:", "PASS" if ok else "FAIL")
