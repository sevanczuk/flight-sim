#!/usr/bin/env python3
"""
assemble_gnx375_spec.py — Assemble GNX 375 Functional Spec V1 from 7 fragment files.

Run from project root:
  python scripts/assemble_gnx375_spec.py [--verbose] [--check] [--partial]
                                          [--manifest <path>] [--fragments-dir <path>]
                                          [--output <path>]
                                          [--review-priority-guide <path>]
"""

import argparse
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

DEFAULT_MANIFEST = "docs/specs/GNX375_Functional_Spec_V1.md"
DEFAULT_FRAGMENTS_DIR = "docs/specs/fragments"
DEFAULT_OUTPUT = "docs/specs/GNX375_Functional_Spec_V1_aggregate.md"
EXPECTED_FRAGMENT_COUNT = 7

# H1 fragment header pattern — accepts em-dash (—), en-dash (–), or plain hyphen
_H1_RE = re.compile(
    r"^#\s+GNX\s+375\s+Functional\s+Spec\s+V1\s+[—–-]\s+Fragment\s+[A-G]\s*$"
)
_COUPLING_RE = re.compile(r"^##\s+Coupling Summary\s*$")


# ---------------------------------------------------------------------------
# Manifest parsing
# ---------------------------------------------------------------------------

def parse_manifest(manifest_path: Path) -> list[tuple[int, str, str]]:
    """Return sorted list of (order, rel_fragment_path, covers) from manifest table."""
    text = manifest_path.read_text(encoding="utf-8")
    fragments = []
    in_table = False

    for line in text.splitlines():
        if "| Order |" in line and "Fragment file" in line:
            in_table = True
            continue
        if in_table:
            if re.match(r"^\|[\s-]+\|", line):
                continue
            if not line.startswith("|"):
                in_table = False
                continue
            cols = [c.strip() for c in line.split("|")[1:-1]]
            if len(cols) < 3:
                continue
            order_str = cols[0].strip()
            if not order_str.isdigit():
                continue
            m = re.search(r"`([^`]+)`", cols[2])
            if not m:
                continue
            covers = cols[3].strip() if len(cols) > 3 else ""
            fragments.append((int(order_str), m.group(1), covers))

    fragments.sort(key=lambda x: x[0])
    return fragments


# ---------------------------------------------------------------------------
# Per-fragment strip operations
# ---------------------------------------------------------------------------

def strip_yaml_front_matter(lines: list[str]) -> tuple[list[str], int]:
    """Strip YAML front-matter (opening --- ... ---). Returns (remaining, count_stripped)."""
    if not lines or lines[0].rstrip() != "---":
        return lines, 0
    for i in range(1, len(lines)):
        if lines[i].rstrip() == "---":
            return lines[i + 1 :], i + 1
    return lines, 0


def strip_h1_and_intro(lines: list[str]) -> tuple[list[str], int, int]:
    """Strip H1 fragment header and optional standard intro paragraph.

    Returns (remaining, h1_stripped_count, intro_stripped_count).
    Conservative: only strips the intro if it starts with 'This is ' or 'This fragment '.
    """
    i = 0
    h1_count = 0
    intro_count = 0

    # Skip leading blank lines
    while i < len(lines) and lines[i].strip() == "":
        i += 1

    if i < len(lines) and _H1_RE.match(lines[i].rstrip()):
        h1_count = 1
        i += 1

        blank_start = i
        while i < len(lines) and lines[i].strip() == "":
            i += 1
        blanks_after_h1 = i - blank_start

        # Heuristic: strip standard piecewise preamble paragraph
        if i < len(lines):
            first = lines[i].strip()
            if first.startswith("This is ") or first.startswith("This fragment "):
                para_start = i
                while i < len(lines) and lines[i].strip() != "":
                    i += 1
                intro_count = (i - para_start) + blanks_after_h1
                # Skip blank line(s) after intro
                while i < len(lines) and lines[i].strip() == "":
                    i += 1
                return lines[i:], h1_count, intro_count

        # Intro not recognised — restore blank lines so body is intact
        i = blank_start

    return lines[i:], h1_count, intro_count


def strip_coupling_summary(lines: list[str]) -> tuple[list[str], int]:
    """Strip ## Coupling Summary block and any immediately preceding --- separator.

    Walks backward past blank lines from the ## Coupling Summary line to find ---.
    Returns (remaining, count_stripped).
    """
    for idx, line in enumerate(lines):
        if _COUPLING_RE.match(line.rstrip()):
            cut = idx

            # Walk back past blank lines to find an optional --- separator
            j = cut - 1
            while j >= 0 and lines[j].strip() == "":
                j -= 1
            if j >= 0 and lines[j].rstrip() == "---":
                cut = j
                # Also drop one blank line immediately before the ---
                if cut > 0 and lines[cut - 1].strip() == "":
                    cut -= 1

            stripped = len(lines) - cut
            return lines[:cut], stripped

    return lines, 0


def trim_trailing_blanks(lines: list[str]) -> list[str]:
    while lines and lines[-1].strip() == "":
        lines.pop()
    return lines


def process_fragment(frag_path: Path) -> tuple[list[str], dict]:
    """Read and strip a single fragment. Returns (body_lines, stats_dict)."""
    raw = frag_path.read_text(encoding="utf-8")
    lines = raw.splitlines()
    input_count = len(lines)

    lines, yaml_n = strip_yaml_front_matter(lines)
    lines, h1_n, intro_n = strip_h1_and_intro(lines)
    lines, coupling_n = strip_coupling_summary(lines)
    lines = trim_trailing_blanks(lines)

    return lines, {
        "input_lines": input_count,
        "yaml_stripped": yaml_n,
        "h1_stripped": h1_n + intro_n,
        "coupling_stripped": coupling_n,
        "body_lines": len(lines),
    }


# ---------------------------------------------------------------------------
# Provenance block
# ---------------------------------------------------------------------------

def build_provenance(manifest_path: str, output_path: str) -> list[str]:
    ts = datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds")
    return [
        "# GNX 375 Functional Spec V1",
        "",
        "<!-- Assembled from seven part files via scripts/assemble_gnx375_spec.py.",
        f"     Source manifest: {manifest_path}",
        "     Fragments: GNX375_Functional_Spec_V1_part_{A..G}.md",
        f"     Generated: {ts} -->",
        "",
    ]


# ---------------------------------------------------------------------------
# Verification helpers
# ---------------------------------------------------------------------------

def _collect_heading_targets(lines: list[str]) -> set[str]:
    """Build set of section keys present in the aggregate."""
    targets: set[str] = set()
    h2_sec = re.compile(r"^##\s+(\d+)\.\s+")
    h3_sec = re.compile(r"^###\s+(\d+\.[A-Za-z0-9]+)\b")
    h2_app = re.compile(r"^##\s+Appendix\s+([A-C])\b", re.IGNORECASE)
    h3_app = re.compile(r"^###\s+([A-C]\.\d+)\b", re.IGNORECASE)

    for line in lines:
        if m := h2_sec.match(line):
            targets.add(m.group(1))
        elif m := h3_sec.match(line):
            targets.add(m.group(1))
        elif m := h2_app.match(line):
            targets.add(f"Appendix {m.group(1).upper()}")
        elif m := h3_app.match(line):
            targets.add(m.group(1).upper())
    return targets


def _collect_h3_headings(lines: list[str]) -> list[tuple[int, str]]:
    h3 = re.compile(r"^###\s+(.+)")
    return [(i, m.group(1).strip()) for i, line in enumerate(lines) if (m := h3.match(line))]


def verify_section_numbering(lines: list[str]) -> tuple[bool, list[str]]:
    """Check §1–§15 each appear exactly once at H2; Appendices A, B, C appear at H2."""
    h2_sec = re.compile(r"^##\s+(\d+)\.\s+")
    h2_app = re.compile(r"^##\s+Appendix\s+([A-C])\b", re.IGNORECASE)

    found_sec: dict[int, int] = {}
    found_app: set[str] = set()
    issues: list[str] = []

    for i, line in enumerate(lines):
        if m := h2_sec.match(line):
            n = int(m.group(1))
            if n in found_sec:
                issues.append(f"Duplicate §{n} at line {i+1} (first at {found_sec[n]+1})")
            else:
                found_sec[n] = i
        if m := h2_app.match(line):
            found_app.add(m.group(1).upper())

    missing_sec = [n for n in range(1, 16) if n not in found_sec]
    extra_sec = sorted(n for n in found_sec if n > 15)
    missing_app = [x for x in "ABC" if x not in found_app]

    if missing_sec:
        issues.append(f"Missing §§: {missing_sec}")
    if extra_sec:
        issues.append(f"Unexpected sections beyond §15: {extra_sec}")
    if missing_app:
        issues.append(f"Missing Appendices: {missing_app}")

    return not issues, issues


def verify_subsection_integrity(lines: list[str]) -> tuple[bool, list[str]]:
    """Spot-check §4.1–§4.10, §7 ordering, §14 (6), §15 (7), Appendix A (5)."""
    h3s = _collect_h3_headings(lines)
    issues: list[str] = []

    # §4.1 – §4.10
    s4_re = re.compile(r"^4\.(\d+)\b")
    found_s4 = {int(m.group(1)) for _, h in h3s if (m := s4_re.match(h))}
    miss_s4 = [n for n in range(1, 11) if n not in found_s4]
    if miss_s4:
        issues.append(f"§4 missing sub-sections: {miss_s4}")

    # §7 numeric 7.1–7.9 then lettered 7.A–7.M, in order
    s7n_re = re.compile(r"^7\.(\d+)\b")
    s7l_re = re.compile(r"^7\.([A-M])\b")
    s7n = [(pos, int(m.group(1))) for pos, h in h3s if (m := s7n_re.match(h))]
    s7l = [(pos, m.group(1)) for pos, h in h3s if (m := s7l_re.match(h))]

    miss_s7n = [n for n in range(1, 10) if n not in {v for _, v in s7n}]
    miss_s7l = [c for c in "ABCDEFGHIJKLM" if c not in {v for _, v in s7l}]
    if miss_s7n:
        issues.append(f"§7 missing numeric sub-sections: {miss_s7n}")
    if miss_s7l:
        issues.append(f"§7 missing lettered sub-sections: {miss_s7l}")
    if s7n and s7l:
        last_num_line = max(p for p, _ in s7n)
        first_let_line = min(p for p, _ in s7l)
        if last_num_line > first_let_line:
            issues.append("§7: lettered sub-sections appear before some numeric sub-sections")

    # §14: 6 sub-sections
    s14_re = re.compile(r"^14\.\d+\b")
    c14 = sum(1 for _, h in h3s if s14_re.match(h))
    if c14 != 6:
        issues.append(f"§14 expected 6 sub-sections, found {c14}")

    # §15: 7 sub-sections
    s15_re = re.compile(r"^15\.\d+\b")
    c15 = sum(1 for _, h in h3s if s15_re.match(h))
    if c15 != 7:
        issues.append(f"§15 expected 7 sub-sections, found {c15}")

    # Appendix A: 5 sub-sections
    appa_re = re.compile(r"^A\.\d+\b", re.IGNORECASE)
    ca = sum(1 for _, h in h3s if appa_re.match(h))
    if ca != 5:
        issues.append(f"Appendix A expected 5 sub-sections, found {ca}")

    return not issues, issues


def verify_no_duplicate_h2(lines: list[str]) -> tuple[bool, list[str]]:
    h2 = re.compile(r"^##\s+(.+)")
    seen: dict[str, int] = {}
    dups: list[str] = []
    for i, line in enumerate(lines):
        if m := h2.match(line):
            key = m.group(1).strip()
            if key in seen:
                dups.append(f"Line {i+1}: '{key}' (also at line {seen[key]+1})")
            else:
                seen[key] = i
    return not dups, dups


def verify_no_coupling_summary(lines: list[str]) -> tuple[bool, list[str]]:
    found = [i + 1 for i, l in enumerate(lines) if _COUPLING_RE.match(l.rstrip())]
    return not found, [f"Line {n}" for n in found]


def verify_no_fragment_headers(lines: list[str]) -> tuple[bool, list[str]]:
    found = [i + 1 for i, l in enumerate(lines) if _H1_RE.match(l.rstrip())]
    return not found, [f"Line {n}" for n in found]


def verify_no_yaml_blocks(lines: list[str]) -> tuple[bool, list[str]]:
    """Flag standalone '---' lines followed by a YAML key-value, outside fenced code blocks."""
    in_fence = False
    suspicious: list[str] = []
    for i, line in enumerate(lines):
        s = line.rstrip()
        if not in_fence:
            if re.match(r"^(`{3,}|~{3,})", s):
                in_fence = True
                continue
        else:
            if re.match(r"^(`{3,}|~{3,})", s):
                in_fence = False
            continue

        if s == "---":
            # Only flag if the next line looks like a YAML key-value
            if i + 1 < len(lines) and re.match(r"^[A-Za-z][\w-]*:\s+\S", lines[i + 1]):
                suspicious.append(f"Line {i+1}: '---' followed by YAML-like content")

    return not suspicious, suspicious


def verify_cross_refs(lines: list[str]) -> list[str]:
    """Find §N[.x] and Appendix X references; return list of unresolved ones (warning only)."""
    targets = _collect_heading_targets(lines)
    sec_ref = re.compile(r"§(\d+(?:\.[A-Za-z0-9]+)?)")  # § = U+00A7
    app_ref = re.compile(r"\bAppendix\s+([A-C])\b", re.IGNORECASE)

    checked: set[str] = set()
    unresolved: list[str] = []

    for line in lines:
        if line.startswith("#"):
            continue
        for m in sec_ref.finditer(line):
            ref = m.group(1)
            if ref in checked:
                continue
            checked.add(ref)
            top = ref.split(".")[0]
            if ref not in targets and top not in targets:
                unresolved.append(f"§{ref}")
        for m in app_ref.finditer(line):
            ref = f"Appendix {m.group(1).upper()}"
            if ref in checked:
                continue
            checked.add(ref)
            if ref not in targets:
                unresolved.append(ref)

    return unresolved


# ---------------------------------------------------------------------------
# Verification runner
# ---------------------------------------------------------------------------

def run_verification(
    assembled: list[str], verbose: bool = False
) -> tuple[bool, list[tuple[str, str, list[str]]]]:
    """Run all checks. Returns (all_gating_pass, results_list)."""
    results: list[tuple[str, str, list[str]]] = []
    gating_pass = True

    gating_checks = [
        ("Section numbering continuity (§1–§15 + Appendices A–C at H2)", verify_section_numbering),
        ("Sub-section integrity spot-checks", verify_subsection_integrity),
        ("No duplicate H2 headings", verify_no_duplicate_h2),
        ("No '## Coupling Summary' in aggregate", verify_no_coupling_summary),
        ("No fragment header lines in aggregate", verify_no_fragment_headers),
        ("No YAML front-matter blocks", verify_no_yaml_blocks),
    ]
    for label, fn in gating_checks:
        ok, details = fn(assembled)
        status = "PASS" if ok else "FAIL"
        if not ok:
            gating_pass = False
        results.append((label, status, details))

    # Cross-ref: warning only
    unresolved = verify_cross_refs(assembled)
    if unresolved:
        status = f"WARN ({len(unresolved)} unresolved)"
        results.append(("Cross-reference resolution", status, unresolved[:10]))
    else:
        results.append(("Cross-reference resolution", "PASS (0 unresolved)", []))

    # Informational
    results.append(("Total line count", str(len(assembled)), []))

    return gating_pass, results


def print_verification_results(results: list[tuple[str, str, list[str]]]) -> None:
    print("\n=== Verification Results ===")
    for label, status, details in results:
        print(f"  [{status}] {label}")
        for d in details[:5]:
            print(f"      - {d}")
        if len(details) > 5:
            print(f"      ... ({len(details) - 5} more)")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    ap = argparse.ArgumentParser(
        description="Assemble GNX 375 Functional Spec V1 aggregate from fragment files."
    )
    ap.add_argument("--manifest", default=DEFAULT_MANIFEST, help="Path to manifest spec")
    ap.add_argument("--fragments-dir", default=DEFAULT_FRAGMENTS_DIR, help="Fragment directory")
    ap.add_argument("--output", default=DEFAULT_OUTPUT, help="Output aggregate path")
    ap.add_argument("--partial", action="store_true", help="Allow assembly with missing fragments")
    ap.add_argument("--check", action="store_true", help="Verify in memory; do not write output")
    ap.add_argument("--verbose", action="store_true", help="Print per-fragment strip statistics")
    ap.add_argument(
        "--review-priority-guide",
        metavar="PATH",
        type=str,
        default=None,
        help="Path to a markdown file to prepend to the assembled aggregate. "
             "If supplied, the file's content is inserted between the H1 metadata block "
             "(H1 title + HTML assembly comment) and the '---' separator. "
             "If absent, no priority guide is prepended (default).",
    )
    args = ap.parse_args()

    manifest_path = Path(args.manifest)
    if not manifest_path.exists():
        print(f"ERROR: Manifest not found: {manifest_path}", file=sys.stderr)
        sys.exit(1)

    fragments_info = parse_manifest(manifest_path)
    if not fragments_info:
        print("ERROR: No fragments found in manifest table.", file=sys.stderr)
        sys.exit(1)

    print(f"Manifest: {manifest_path} — {len(fragments_info)} fragment(s) in table")

    spec_dir = manifest_path.parent  # docs/specs/
    all_bodies: list[list[str]] = []
    all_stats: list[dict] = []
    missing_letters: list[str] = []
    present_letters: list[str] = []

    for order, rel_path, covers in fragments_info:
        frag_path = spec_dir / rel_path
        lm = re.search(r"_part_([A-G])\.md$", str(frag_path), re.IGNORECASE)
        letter = lm.group(1) if lm else str(order)

        if not frag_path.exists():
            if args.partial:
                print(f"WARNING: Fragment {letter} missing at {frag_path} — inserting placeholder.")
                placeholder = [f"<!-- Fragment {letter} ({covers}) not yet authored. Placeholder. -->"]
                all_bodies.append(placeholder)
                all_stats.append(
                    {
                        "letter": letter,
                        "input_lines": 0,
                        "yaml_stripped": 0,
                        "h1_stripped": 0,
                        "coupling_stripped": 0,
                        "body_lines": 1,
                        "placeholder": True,
                    }
                )
                missing_letters.append(letter)
            else:
                print(f"ERROR: Fragment {letter} not found: {frag_path}", file=sys.stderr)
                print("  Use --partial to assemble with missing fragments.", file=sys.stderr)
                sys.exit(1)
            continue

        body, stats = process_fragment(frag_path)
        stats["letter"] = letter
        stats["placeholder"] = False
        all_bodies.append(body)
        all_stats.append(stats)
        present_letters.append(letter)

        if args.verbose:
            print(
                f"  Fragment {letter}: {stats['input_lines']} lines in"
                f" -> {stats['body_lines']} body lines"
                f" (YAML -{stats['yaml_stripped']}, H1+intro -{stats['h1_stripped']},"
                f" Coupling -{stats['coupling_stripped']})"
            )

    if missing_letters:
        print(f"WARNING: Missing fragments: {missing_letters}")

    if args.verbose:
        print("\n=== Strip Statistics ===")
        print(f"  {'Frag':<6} {'Input':>8} {'YAML':>8} {'H1+Intro':>10} {'Coupling':>10} {'Body':>8}")
        for s in all_stats:
            if s.get("placeholder"):
                print(f"  {s['letter']:<6} (placeholder)")
            else:
                print(
                    f"  {s['letter']:<6} {s['input_lines']:>8} {s['yaml_stripped']:>8} "
                    f"{s['h1_stripped']:>10} {s['coupling_stripped']:>10} {s['body_lines']:>8}"
                )
        total_in = sum(s["input_lines"] for s in all_stats if not s.get("placeholder"))
        total_body = sum(s["body_lines"] for s in all_stats if not s.get("placeholder"))
        print(f"  {'TOTAL':<6} {total_in:>8} {'':>8} {'':>10} {'':>10} {total_body:>8}")

    # Assemble
    provenance = build_provenance(args.manifest, args.output)
    assembled: list[str] = list(provenance)
    if args.review_priority_guide:
        guide_text = Path(args.review_priority_guide).read_text(encoding="utf-8").rstrip()
        assembled.extend(guide_text.splitlines())
        assembled.append("")
    for i, body in enumerate(all_bodies):
        assembled.extend(body)
        if i < len(all_bodies) - 1:
            assembled.append("")  # single blank line between fragments

    # Verify
    gating_pass, results = run_verification(assembled, verbose=args.verbose)
    print_verification_results(results)

    if not args.check:
        out_path = Path(args.output)
        out_path.parent.mkdir(parents=True, exist_ok=True)
        out_path.write_text("\n".join(assembled) + "\n", encoding="utf-8")
        print(f"\nOutput written: {out_path} ({len(assembled)} lines)")
    else:
        print(f"\n[--check mode] Aggregate not written. In-memory line count: {len(assembled)}")

    if not gating_pass:
        print("\nERROR: One or more gating verification checks FAILED.", file=sys.stderr)
        sys.exit(1)

    print("\nAll gating verification checks PASS.")
    sys.exit(0)


if __name__ == "__main__":
    main()
