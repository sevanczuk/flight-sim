"""Diagnostic: how many parsed function records have non-empty see_also or cross_references?

This answers: did the parser actually preserve AMAPI cross-references per Turn 50
patch to the prompt?

Run: python scripts/diagnostic_parser_xref_check.py
"""
import json
from pathlib import Path
from collections import Counter

PARSED_DIR = Path("assets/air_manager_api/parsed/by_function")

def main():
    json_files = sorted(PARSED_DIR.glob("*.json"))
    print(f"Scanning {len(json_files)} parsed function records...\n")

    stats = Counter()
    see_also_examples = []
    cross_ref_examples = []
    description_link_candidates = []

    for jf in json_files:
        rec = json.load(open(jf, encoding='utf-8'))
        stats['total'] += 1
        sa = rec.get('see_also', [])
        cr = rec.get('cross_references', [])
        desc = rec.get('description', '') or ''
        if sa:
            stats['has_see_also'] += 1
            if len(see_also_examples) < 5:
                see_also_examples.append((jf.stem, sa))
        if cr:
            stats['has_cross_refs'] += 1
            if len(cross_ref_examples) < 5:
                cross_ref_examples.append((jf.stem, cr))
        if '[' in desc and '](' in desc:
            stats['has_inline_md_links_in_desc'] += 1
            if len(description_link_candidates) < 3:
                description_link_candidates.append((jf.stem, desc[:200]))
        stats['has_none_of_the_above'] += 1 if (not sa and not cr and not ('[' in desc and '](' in desc)) else 0

    print(f"{'='*70}")
    print("STATS")
    print(f"{'='*70}")
    for k, v in sorted(stats.items()):
        print(f"  {k:40s} {v:>6d}")

    print(f"\n{'='*70}")
    print("SAMPLE: records with non-empty see_also")
    print(f"{'='*70}")
    if not see_also_examples:
        print("  (NONE — every single function record has see_also=[])")
    for name, sa in see_also_examples:
        print(f"  {name}:")
        for entry in sa[:3]:
            print(f"    {entry}")

    print(f"\n{'='*70}")
    print("SAMPLE: records with non-empty cross_references")
    print(f"{'='*70}")
    if not cross_ref_examples:
        print("  (NONE — every single function record has cross_references=[])")
    for name, cr in cross_ref_examples:
        print(f"  {name}:")
        for entry in cr[:3]:
            print(f"    {entry}")

    print(f"\n{'='*70}")
    print("SAMPLE: descriptions with inline markdown links")
    print(f"{'='*70}")
    if not description_link_candidates:
        print("  (NONE)")
    for name, desc in description_link_candidates:
        print(f"  {name}: {desc}")

if __name__ == "__main__":
    main()
