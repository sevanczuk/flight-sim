import sys

path = sys.argv[1]
with open(path, "rb") as f:
    data = f.read()

count = data.count(b"\xef\xbf\xbd")
print(f"U+FFFD replacement char count: {count}")
sys.exit(0 if count == 0 else 1)
