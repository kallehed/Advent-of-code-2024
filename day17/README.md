
part1:
run: `swift run -c release < data.txt`


for part2 I looked at the bit patterns of the solutions that cleared the initial numbers, and hard-setting those initial 8-bits, you could easily brute-force the rest to find the solution. So yeah it's hard coded for my version of part2. I almost wanted to output assembly instructions or something, but this was easier. 

I actually kind of like swift. Even though it's like cursed rust. 
It has all the good llvm features. Like integers. It has closures. Capturing values of the stack. Lots of behind the scenes stuff which makes me scared.  The documentation was pretty okay. It looks really clean, not having semicolons really clicked for me on this one, especially with the switch statements: could get some beautiful code. 
