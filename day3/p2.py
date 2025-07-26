import re, sys

sum = 0
do = True
text = sys.stdin.read()
for match in re.finditer(r"(?P<mul>mul\(([0-9]+),([0-9]+)\))|(?P<do>do\(\))|(?P<don>don't\(\))", text):
    if match.group("mul"):
        (_, a,b, _, _) = match.groups();
        if do:
            sum += int(a)*int(b)
    elif match.group("do"):
        do = True
    elif match.group("don"):
        do = False;
    else:
        raise Exception("what")
print(sum)
