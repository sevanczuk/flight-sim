"""
Build assets/gnx375_pymupdf_v1_0_1/page_number_map.json from page_metadata.json.

Task: GNX375-PAGEMAP-PYMUPDF-01
Schema version: 2.0
Override semantics: per page_overrides.json (see D-28 for page 2 PAP 22 entry)
"""

import json
import sys
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).parent.parent
METADATA_PATH = ROOT / "assets/gnx375_pymupdf_v1_0_1/page_metadata.json"
OVERRIDES_PATH = ROOT / "assets/gnx375_pymupdf_v1_0_1/page_overrides.json"
OUTPUT_PATH = ROOT / "assets/gnx375_pymupdf_v1_0_1/page_number_map.json"

RECOGNIZED_OVERRIDE_FIELDS = {"printed_page_number"}


# ---------------------------------------------------------------------------
# Phase A — Read inputs
# ---------------------------------------------------------------------------

def load_inputs():
    with open(METADATA_PATH, encoding="utf-8") as f:
        metadata_in = json.load(f)

    if OVERRIDES_PATH.exists():
        with open(OVERRIDES_PATH, encoding="utf-8") as f:
            overrides_in = json.load(f)
        overrides_file_str = "assets/gnx375_pymupdf_v1_0_1/page_overrides.json"
    else:
        overrides_in = {"overrides": {}}
        overrides_file_str = None
        print("WARN: page_overrides.json not found; proceeding with no overrides", file=sys.stderr)

    # Validate input schema
    required_top = {"extracted_at", "source_pdf", "page_count", "footer_ratio", "header_ratio", "pages"}
    missing = required_top - set(metadata_in.keys())
    if missing:
        print(f"ERROR: page_metadata.json missing top-level keys: {missing}", file=sys.stderr)
        sys.exit(1)

    if metadata_in["page_count"] != len(metadata_in["pages"]):
        print(
            f"ERROR: page_count={metadata_in['page_count']} != len(pages)={len(metadata_in['pages'])}",
            file=sys.stderr,
        )
        sys.exit(1)

    for k, rec in metadata_in["pages"].items():
        for field in ("footer_text_raw", "printed_page_number", "parse_warning"):
            if field not in rec:
                print(f"ERROR: page {k} missing field '{field}'", file=sys.stderr)
                sys.exit(1)

    return metadata_in, overrides_in, overrides_file_str


# ---------------------------------------------------------------------------
# Phase B — Apply overrides and build maps
# ---------------------------------------------------------------------------

def build_maps(metadata_in, overrides_in, overrides_file_str):
    pages = metadata_in["pages"]
    raw_overrides = overrides_in.get("overrides", {})

    physical_to_logical = {}
    logical_to_physical = {}
    unparseable_pages = []
    extras = {}
    overrides_applied = []
    duplicates_tracker = {}  # printed_page_number -> list of int physical pages

    for key, rec in pages.items():
        effective_ppn = rec["printed_page_number"]
        override_applied = False
        override_rationale_ref = None

        if key in raw_overrides:
            ov = raw_overrides[key]
            unknown_fields = set(ov.keys()) - RECOGNIZED_OVERRIDE_FIELDS - {"rationale", "decision_ref"}
            for uf in unknown_fields:
                print(f"WARN: override for page {key} has unrecognized field '{uf}'", file=sys.stderr)

            if "printed_page_number" in ov:
                effective_ppn = ov["printed_page_number"]
                override_applied = True
                override_rationale_ref = ov.get("decision_ref")
                overrides_applied.append({
                    "physical_page": int(key),
                    "field": "printed_page_number",
                    "to": effective_ppn,
                    "rationale": ov.get("rationale", ""),
                    "decision_ref": ov.get("decision_ref", ""),
                })

        physical_to_logical[key] = effective_ppn

        if effective_ppn is not None:
            if effective_ppn in logical_to_physical:
                # Duplicate — record both occurrences
                if effective_ppn not in duplicates_tracker:
                    duplicates_tracker[effective_ppn] = [logical_to_physical[effective_ppn]]
                duplicates_tracker[effective_ppn].append(int(key))
            else:
                logical_to_physical[effective_ppn] = int(key)
        else:
            unparseable_pages.append(int(key))

        extras_rec = {
            "footer_text_raw": rec["footer_text_raw"],
            "parse_warning": rec["parse_warning"],
        }
        if override_applied:
            extras_rec["override_applied"] = True
            extras_rec["override_rationale_ref"] = override_rationale_ref
        extras[key] = extras_rec

    # Warn about override keys not in pages
    for ov_key in raw_overrides:
        if ov_key not in pages:
            print(
                f"WARN: override key '{ov_key}' not found in page_metadata.json pages; skipping",
                file=sys.stderr,
            )

    logical_duplicates = [
        {"printed_page_number": ppn, "physical_pages": sorted(phys_list)}
        for ppn, phys_list in duplicates_tracker.items()
    ]

    return (
        physical_to_logical,
        logical_to_physical,
        unparseable_pages,
        extras,
        overrides_applied,
        logical_duplicates,
    )


# ---------------------------------------------------------------------------
# Phase C — Sort and assemble output
# ---------------------------------------------------------------------------

def sort_and_assemble(
    metadata_in,
    overrides_file_str,
    physical_to_logical,
    logical_to_physical,
    unparseable_pages,
    extras,
    overrides_applied,
    logical_duplicates,
):
    # Sort physical_to_logical by int key ascending
    sorted_p2l = {k: physical_to_logical[k] for k in sorted(physical_to_logical, key=int)}

    # Sort logical_to_physical by physical page (value) ascending
    sorted_l2p = dict(sorted(logical_to_physical.items(), key=lambda kv: kv[1]))

    # Sort unparseable ascending (already ints)
    sorted_unparseable = sorted(unparseable_pages)

    # Sort logical_duplicates by printed_page_number string
    sorted_duplicates = sorted(logical_duplicates, key=lambda r: r["printed_page_number"])

    # Sort extras by int key ascending
    sorted_extras = {k: extras[k] for k in sorted(extras, key=int)}

    parsed_count = sum(1 for v in sorted_p2l.values() if v is not None)
    unparseable_count = sum(1 for v in sorted_p2l.values() if v is None)
    page_count = len(sorted_p2l)

    metadata_block = {
        "schema_version": "2.0",
        "extraction_dir": "assets/gnx375_pymupdf_v1_0_1/",
        "extraction_tool": "pymupdf-extract V1.0.1",
        "physical_page_count": page_count,
        "parsed_count": parsed_count,
        "unparseable_count": unparseable_count,
        "generated": datetime.now().astimezone().isoformat(timespec="seconds"),
        "source_pdf_path": metadata_in["source_pdf"],
        "extracted_at": metadata_in["extracted_at"],
        "footer_ratio": metadata_in["footer_ratio"],
        "header_ratio": metadata_in["header_ratio"],
        "overrides_file": overrides_file_str,
        "overrides_applied": overrides_applied,
    }

    out = {
        "schema_version": "2.0",
        "physical_to_logical": sorted_p2l,
        "logical_to_physical": sorted_l2p,
        "unparseable_pages": sorted_unparseable,
        "logical_duplicates": sorted_duplicates,
        "metadata": metadata_block,
        "extras": sorted_extras,
    }

    return out


# ---------------------------------------------------------------------------
# Phase D — Write output
# ---------------------------------------------------------------------------

def write_output(out):
    with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
        json.dump(out, f, indent=2, ensure_ascii=False, sort_keys=False)
        f.write("\n")


# ---------------------------------------------------------------------------
# Phase E — Sanity checks
# ---------------------------------------------------------------------------

def run_sanity_checks(out):
    failures = []

    meta = out["metadata"]
    p2l = out["physical_to_logical"]
    l2p = out["logical_to_physical"]
    unparseable = out["unparseable_pages"]
    duplicates = out["logical_duplicates"]
    extras = out["extras"]

    def check(label, cond, detail=""):
        if cond:
            print(f"  OK  {label}")
        else:
            print(f"  FAIL {label}{': ' + detail if detail else ''}")
            failures.append(label)

    print("\nRunning sanity checks:")

    # 1 — Schema completeness
    expected_keys = {"schema_version", "physical_to_logical", "logical_to_physical",
                     "unparseable_pages", "logical_duplicates", "metadata", "extras"}
    check(
        "1. Schema completeness",
        set(out.keys()) == expected_keys and out["schema_version"] == "2.0",
        f"keys={set(out.keys())}, schema_version={out['schema_version']!r}",
    )

    # 2 — Page count
    check(
        "2. Page count",
        len(p2l) == meta["physical_page_count"] == 310,
        f"len(p2l)={len(p2l)}, physical_page_count={meta['physical_page_count']}",
    )

    # 3 — Conservation
    check(
        "3. Conservation",
        meta["parsed_count"] + meta["unparseable_count"] == meta["physical_page_count"]
        and meta["parsed_count"] == 306
        and meta["unparseable_count"] == 4,
        f"parsed={meta['parsed_count']}, unparseable={meta['unparseable_count']}, total={meta['physical_page_count']}",
    )

    # 4 — Unparseable list
    check(
        "4. Unparseable list",
        len(unparseable) == meta["unparseable_count"] == 4
        and all(isinstance(x, int) for x in unparseable)
        and set(unparseable) == {1, 2, 309, 310},
        f"unparseable={unparseable}",
    )

    # 5 — Forward-inverse roundtrip
    roundtrip_ok = True
    for phys_str, logical in p2l.items():
        if logical is not None:
            if l2p.get(logical) != int(phys_str):
                roundtrip_ok = False
                break
    for logical, phys_int in l2p.items():
        if p2l.get(str(phys_int)) != logical:
            roundtrip_ok = False
            break
    check("5. Forward-inverse roundtrip", roundtrip_ok)

    # 6 — No unexpected duplicates
    check("6. No unexpected duplicates", duplicates == [], f"duplicates={duplicates}")

    # 7 — Spot checks
    spot_ok = (
        p2l.get("3") == "i"
        and p2l.get("4") == "ii"
        and p2l.get("308") == "9-4"
        and l2p.get("i") == 3
        and l2p.get("9-4") == 308
    )
    check(
        "7. Spot checks",
        spot_ok,
        f"p2l[3]={p2l.get('3')!r}, p2l[4]={p2l.get('4')!r}, p2l[308]={p2l.get('308')!r}, "
        f"l2p[i]={l2p.get('i')!r}, l2p[9-4]={l2p.get('9-4')!r}",
    )

    # 8 — Override audit
    ov_applied = meta["overrides_applied"]
    extras_with_override = [k for k, v in extras.items() if v.get("override_applied") is True]
    override_ok = (
        len(ov_applied) == 1
        and ov_applied[0]["physical_page"] == 2
        and ov_applied[0]["decision_ref"] == "D-28"
        and extras.get("2", {}).get("override_applied") is True
        and extras.get("2", {}).get("override_rationale_ref") == "D-28"
        and len(extras_with_override) == len(ov_applied)
    )
    check(
        "8. Override audit",
        override_ok,
        f"overrides_applied={ov_applied}, extras_with_override={extras_with_override}",
    )

    return failures


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    print("Phase A: Reading inputs...")
    metadata_in, overrides_in, overrides_file_str = load_inputs()
    print(f"  page_metadata.json: {len(metadata_in['pages'])} pages")
    print(f"  page_overrides.json: {len(overrides_in.get('overrides', {}))} override(s)")

    print("Phase B: Applying overrides and building maps...")
    (
        physical_to_logical,
        logical_to_physical,
        unparseable_pages,
        extras,
        overrides_applied,
        logical_duplicates,
    ) = build_maps(metadata_in, overrides_in, overrides_file_str)
    print(f"  parsed={sum(1 for v in physical_to_logical.values() if v is not None)}, "
          f"unparseable={len(unparseable_pages)}, overrides_applied={len(overrides_applied)}")

    print("Phase C: Sorting and assembling output...")
    out = sort_and_assemble(
        metadata_in,
        overrides_file_str,
        physical_to_logical,
        logical_to_physical,
        unparseable_pages,
        extras,
        overrides_applied,
        logical_duplicates,
    )

    print("Phase D: Writing output...")
    write_output(out)
    print(f"  Written: {OUTPUT_PATH}")

    print("Phase E: Running sanity checks...")
    failures = run_sanity_checks(out)

    if failures:
        print(f"\n{len(failures)} sanity check(s) FAILED: {failures}")
        sys.exit(1)
    else:
        print("\nAll 8 sanity checks passed. page_number_map.json written.")


if __name__ == "__main__":
    main()
