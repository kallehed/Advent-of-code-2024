

HOW TO RUNNNNNNNNNN: `zig build run < data.txt`   ... not confusing at all ...

dev mode: `watch -c --differences -c -n 0.4 "zig build run --color on < data.txt"`





- I HATE ZIGGGGGGG!!!
- Worst language. Even worse than c somehow. 
- it's like someone met a horrible 10M line c codebase with recursive macros
- and swung hard into the opposite direction...

i like `zig std` though. 






# Some prolog stuff, cuz I tried that first but gave up:

lmao great easter egg prolog:
```
?- X.
% ... 1,000,000 ............ 10,000,000 years later
% 
%       >> 42 << (last release gives the question)
```


stuff:

```

listing(asd) gives info about asd.

% list head tail notation
[Head | Tail]   % head/tail notation
[1,2,3|Rest]    % list starting with 1,2,3

% extract arguments
?- P = point(3,4), arg(1, P, X), arg(2, P, Y).
P = point(3, 4),
X = 3,
Y = 4.

% _ matches anything but doesn't bind to a variable
age(Person, _)

% index into "array"
L = [1,2,3], nth0(0, L, X).

```
