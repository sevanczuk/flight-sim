"""
C2.2-E Compliance check: U+FFFD replacement character detection.
Per D-08, saved for audit trail.
Usage: python check_ufffd.py <file_path>
"""

import sys


def count_ufffd(filepath: str) -> int:
    """Count U+FFFD (0xEF 0xBF 0xBD) bytes in a UTF-8 file."""
    pattern = bytes([0xEF, 0xBF, 0xBD])
    with open(filepath, "rb") as f:
        data = f.read()
    count = 0
    i = 0
    while i < len(data) - 2:
        if data[i:i+3] == pattern:
            count += 1
            i += 3
        else:
            i += 1
    return count


if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else \
        "docs/specs/fragments/GNX375_Functional_Spec_V1_part_E.md"
    n = count_ufffd(path)
    print(f"U+FFFD count in {path}: {n}")
    sys.exit(0 if n == 0 else 1)
