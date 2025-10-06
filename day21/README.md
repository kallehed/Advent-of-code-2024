
run p1: `elixir p1.exs`
run p2: `elixir p2.exs`

p2 is of course faster.

We are constructing the minimal code to press a sequence of buttons. 
One will probably want to do this from the ground  up instead of from the 'human'
So we will have to make some assumptions or some anzats
Let's say for the first robot, we find all the shortest paths to press our wanted buttons. 
Could there be a longer path for the first robot, which creates an overall shorter path for the whole system? 
If the first robot takes a longer path, that means the second has to press more buttons to move it, which means the third ....
So no, only the shortest paths for the first robot could be viable solutions for the whole system. There is really no reason for the first robot to move more than it has to. 
BUT importantly, the different same-length paths of the first robot could matter. Because of the layout of the directional keypad, it may have to move less 
HM but is my assumption correct? Let's say we use another path for robot 1. That path will have to be atleast 2 steps longer. But because the second order robots will have to go to 'A' and press it, that means an extra step in the first robot ballons into many more operations. It has too. 
So continuing on my same-length paths. They could influence the total path, like if a second robot has to walk less because left and right are 2 spaces apart or something. So you can probably not just take one of them. 
SO: you take the set of minimal presses the first keypad has to do, to make the first robot press the desired buttons. Now you have a set of keypresses on the keypad with the same length. For each of these sets we will generate a new set, the minimal set of keypresses to make the second robot actually press those buttons. We take the minimum of all these sets and gain a new set. 
Do this recursively 2 times. (or 3?) and you will get a set of minimal keypresses you yourself have to press. There you have it, the needed length. 


MORE THINKING: p1 solution obviously doesn't work for p2
N: set of nodes. A is in N, and is a special node. 
num_ways: N -> N -> int         num_ways(D, V) = 2, number of minimal sets of movements between the points
dist: N -> N -> int         dist(D, V) = 3, distance between two nodes
`paths: N -> N -> Set([N])`   the set of minimal presses to move between them (and press it), always has 'A' at the end. 
`next_length: l:[N] -> int  ` = windows2 (A::l) |> dist(&1,&2) |> sum         What's the total cost for this array of nodes. If we try to move a robot to input this path, how long is that path. We start at A. We always start at A, because we are at A at the start, and if it's not the start, why would we just have moved the next robot's hand? No path ends with a movement, because that's silly. We always end with A', so A is always the previous of a path. 

`paths_from_below: N -> N -> Set([N])   = ` for P in (paths A B) filter: next_length(P) is minimal

Lets say you have two nodes R, B. You want to move from R to B. there are num_ways(R,B) ways to do that and it takes dist(R,B) steps. 
Now let's say you have two nodes and you want to move between them. R, B. You take paths(R,B) and get the set of good paths. They all have length num_ways(R,B). But, you want to find the smallest path to take to go between these nodes in these sets. So some are probably better than others. 
let's say `paths(R,B) = {[D,C,D,A], [C,D,D,A], [D,D,C,A]}` on the surface they look equally good. But we want to eagerly remove some of them. So instead of looking at both of them and evaluating all paths to perform both of them, we want to filter them first, because we can deduce that some are better than others. 
So after doing paths(R,B), for each path P in that set, we compute next_length(P) and keep only paths with minimal next_length. Thus we get a new set of paths between two nodes: `paths_from_below(R,B) = {[C,D,D], [D,D,C]}`, which have the same minimal next_length. (thought? maybe there only remains one path after this function?)
Now, from these we want to go further. 

One problem: paths_from_below, the first Node to press, we have to reach that node as well, but where are we? If this is the first thing, we are at 'R'. Or maybe this problem is solved, because we always have to visit 'A' to press inbetween 

Ok I figured out my solution: Memoize neighbors (or 'pairs') of atoms, add :A to when computing distance. Do this recursively, memoizing precisely (a,b, depth). Very cool day actually. Had to write down a bunch of ideas. The explosion of arrays was avoidable, but I didn't see the alternative fast enough. The thing is: you have to see that a pair of two symbols, their distance is independent of what comes after. 



# ELIXIR:::

iex: "h String.trim" gives docs on it

ELIXIR: 
elem({3,4,5}, 2) == 2 s
tuple_size

lists are linked lists hd([1,2]) = 1
tl([1,2]) = [2]


String.split

it has pattern matching!!

pattern match list: 
[head | tail] = ...

match to a value stored in a variable instead of assigning: 
^x = 2. Like backtick in scala.

use underscore to match anything and discard it

case 10 do 
  ^x when y > 3 -> 
    "asd"
  _ -> 
    "rest"
end

cond do 
  true -> 2 
  false -> fd 
end


add = fn a, b -> a + b end
add.(3,4)   ...interesting way to call lambdas I guess?

lambda multiple cases 
x = fn 
  x, y when x > 3 -> 2 
  x, y -> 3 
end

'capture function' to get lambda: &String.length/2

map: 
x = %{:a => 3, 3 => :a}
x[:a] == 3

default argument: def join (asd // "asd") do ... end


Enum.reduce 
Enum.map

create thread: spawn(fn -> 3 end)
