
run p1 and p2: `godot --headless --script p1.gd`

idea: 
===

First: The distance from each node to the end. Without cheats
Because: after we cheat, we want to instantly know our score
So now: when looking for cheats, we simply have a pre-cheat walk. Going around all the ways we can walk, but not reaching somwewhere where we have already been, in more steps. So: Look at shortest places first, and if we reach them again later, don't go there. 
So: do BFS, or have a queue, and mark places already visited. 


Part2: 
So now we enter 'cheat' mode, walk, exit out of cheat mode, for maximum of 20 steps. 
We could just brute-force it. But for each node, we would have to try out a maximum of 4^20 paths, which is very large. Still we have got to find all the cheat-paths that save 100 picoseconds...
Because the grid is pretty small - and walking back to an original spot when cheating won't gain you anything (or (crucially) let you reach a different end-point) so we can limit the cheat-walk to new spots, and with this, the number of steps to compute the result shouldn't be that big.
yes this worked out great.
