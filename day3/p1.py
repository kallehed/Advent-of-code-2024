import re, sys

sum = 0
text = sys.stdin.read()
for (a,b) in re.findall(r"mul\(([0-9]+),([0-9]+)\)", text):
    sum += int(a)*int(b)
print(sum)
