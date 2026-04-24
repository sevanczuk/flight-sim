import sys

filepath = r"docs\specs\fragments\GNX375_Functional_Spec_V1_part_F.md"
with open(filepath, 'rb') as f:
    data = f.read()

# Count U+FFFD (EF BF BD)
ufffd = b'\xef\xbf\xbd'
fffd_count = 0
pos = 0
while True:
    idx = data.find(ufffd, pos)
    if idx == -1:
        break
    fffd_count += 1
    pos = idx + 1

# Count valid § (C2 A7)
sect = b'\xc2\xa7'
sect_count = 0
pos = 0
while True:
    idx = data.find(sect, pos)
    if idx == -1:
        break
    sect_count += 1
    pos = idx + 1

# Check for any C2 not followed by A7 (potential broken section sign)
broken_c2 = 0
for i in range(len(data)-1):
    if data[i] == 0xC2 and data[i+1] != 0xA7:
        broken_c2 += 1
        # Find line number
        line_num = data[:i].count(b'\n') + 1
        context = data[max(0,i-20):i+20]
        print(f"  BROKEN C2 at byte {i}, line {line_num}: {context}")

print(f"U+FFFD count: {fffd_count}")
print(f"Valid § (C2 A7) count: {sect_count}")
print(f"Broken C2 sequences: {broken_c2}")