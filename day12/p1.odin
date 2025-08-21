package p1

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

    mymat :: struct {
        data: []bool,
        cols: int,
    }
    visit :: proc(visited: mymat, y,x: int) -> ^bool {
        return &visited.data[y*visited.cols + x]
    }

    // create 'visited' bool 2darray (initialized to false, I think)
    visited_raw := make([]bool, len(mat) * len(mat[0]));
    for &a in visited_raw do a = false
    visited := mymat{data=visited_raw, cols=len(mat[0])}

    total := 0
    for y in 0..<len(mat) {
        cols := len(mat[y])
        for x in 0..<cols {
            area, fences, _ := explore_area(y, x, mat, visited, mat[y][x])
            if area != 0 {
                //f.printfln("did %c, got area %i, fence: %i", mat[y][x], area, fences)
            }
            total += area * fences
        }
    }

    explore_area :: proc(y, x: int, mat: [][]u8, visited: mymat, plant: u8) -> (area := 0, fences := 0, visited_already := false) {
        if y < 0 || x < 0 || y >= len(mat) || x >= len(mat[0]) do return
        if mat[y][x] != plant do return // gone outside
        place := visit(visited, y, x)
        if place^ do return area, fences, true // already been here
        place^ = true
        area = 1

        dirs := []struct{x,y: int}{{0,1}, {1,0}, {-1,0}, {0,-1}}
        for dir in dirs {
            yy, xx := y+dir.y, x+dir.x
            aa, ff, already := explore_area(yy, xx, mat, visited, plant)
            if aa == 0 && !already {
                // can't go there. 
                fences += 1
            }
            area += aa 
            fences += ff
        }
        return
    }
    f.println("totaL: ", total)
}
