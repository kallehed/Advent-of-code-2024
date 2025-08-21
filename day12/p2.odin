package p2

import fmt "core:fmt"

import os "core:os"

import bytes "core:bytes"

f :: fmt


main :: proc() {
    // data is []u8
    data, success := os.read_entire_file_from_handle(os.stdin)
    defer delete(data)

    if !success {
        f.println("Failed to read input from stdin...");
        return
    }
    // f.println("input: ", data);

    mat : [][]u8 = bytes.split(data, []byte{'\n'})
    // f.println("\nmat: ", mat);

    // for each position, we want to drop down on it
    // and, if it's new, explore it fully from there
    // (get the total cost of it). Those places will
    // be marked as visited, so no double counting
    // will happen. We won't do weird recursion
    // though. No going from one plot to another. 
    // the main loop here will handle getting all
    // the plots

    mymat :: struct($T: typeid) {
        data: []T,
        cols: int,
    }
    visit :: proc(visited: mymat($T), y,x: int) -> ^T {
        return &visited.data[y*visited.cols + x]
    }

    // create 'visited' bool 2darray (initialized to false, I think)
    visited_raw := make([]bool, len(mat) * len(mat[0]));
    for &a in visited_raw do a = false
    visited := mymat(bool){data=visited_raw, cols=len(mat[0])}

    sides_raw := make([][4]bool, len(mat) * len(mat[0]))
    for &a in sides_raw do a = false
    //f.println(sides_raw)
    sides := mymat([4]bool){data=sides_raw, cols=len(mat[0])}

    total := 0
    for y in 0..<len(mat) {
        cols := len(mat[y])
        for x in 0..<cols {
            area, fences, _ := explore_area(y, x, mat, visited, mat[y][x], sides)
            total += area * fences
        }
    }

    // each tile should have bool saying where it's edges are. 
    // these are propogated. So that 
    // if we connect two of the same side, return -1 fences, to account for 
    // the first one that found new part of side and the second one that found
    // so aaa   where xax -> xxx, we don't get 2 sides, but just 1 above side. 

    explore_area :: proc(y, x: int, mat: [][]u8, visited: mymat(bool), plant: u8, sides: mymat([4]bool)) -> (area := 0, fences := 0, visited_already := false) {
        if y < 0 || x < 0 || y >= len(mat) || x >= len(mat[0]) do return
        if mat[y][x] != plant do return // gone outside
        place := visit(visited, y, x)
        if place^ do return area, fences, true // already been here
        place^ = true
        area = 1

        dirs :: [?]([2]int){{0, 1}, {1,0}, {-1,0}, {0,-1}}
        // have to be 'runtime' value, can't be constant AS I INDEX INTO IT LATER!!!!!!!!!
        orths := [][2][2]int{{{1,0}, {-1,0}}, {{0,1},{0,-1}}, {{0,1}, {0,-1}}, {{1,0}, {-1,0}}}
        for dir, idx in dirs {
            yy, xx := y+dir.x, x+dir.y
            aa, ff, already := explore_area(yy, xx, mat, visited, plant, sides)
            if aa == 0 && !already {
                // can't go there. 
                p := visit(sides, y, x)
                p[idx] = true
                // check two orthogonal to ourselves if they have also marked this side.
                marked := 0 
                for orth_dir in orths[idx] {
                    yyy, xxx := y+orth_dir.x, x + orth_dir.y
                    if !(yyy < 0 || xxx < 0 || yyy >= len(mat) || xxx >= len(mat[0])) {
                        // inside
                        p2 := visit(sides, yyy, xxx)
                        // orthogonal neighbor also has this marked
                        if p2[idx] && mat[yyy][xxx] == plant do marked += 1
                    }
                }
                fences += 1 - marked
            }
            area += aa 
            fences += ff
        }
        return
    }
    f.println("totaL: ", total)
}
