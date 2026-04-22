with open('docs/specs/fragments/GNX375_Functional_Spec_V1_part_A.md', 'rb') as f:
    content = f.read()
replacement_count = content.count(b'\xef\xbf\xbd')
print(f'U+FFFD count: {replacement_count}')
if replacement_count > 0:
    lines = content.decode('utf-8', errors='replace').split('\n')
    for i, line in enumerate(lines, 1):
        if '�' in line:
            print(f'line {i}: {line[:120]}')
