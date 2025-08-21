#import "Basic";
#import "String";
os :: #import "File";

// we need @PrintLike, as the format string is checked by a metaprogram for some reason??
// (no 'compilation' of the format strings at compile time???)
println :: (x: string, y: .. Any) #expand { print(#run join(x, "\n"), ..y); } @PrintLike

// OMG why is the syntax for taking the address "*", very confusing error message when using "&"

main :: () {
    data, success := os.read_entire_file("data.txt");

    if !success {
        println("Failed to read input from stdin...");
        return;
    }

    mat : []string = split(data, "\n");
    mymat :: struct {
        data: []bool;
        cols: int;
    };

    visit :: (visited: mymat, y: int, x: int) -> *bool {
        return *visited.data[y*visited.cols + x];
    }

    // create 'visited' bool 2darray (initialized to false, I think)
    // visited_raw := make([]bool, len(mat) * len(mat[0]));
    visited_raw := NewArray(mat.count * mat[0].count, bool);
    for * a : visited_raw   a.* = false;
    visited := mymat.{data=visited_raw, cols=mat[0].count};

    rang :: (x: $T) -> T #expand { return   max(x-1, 0) ;}

    explore_area :: (y: int, x: int, mat: []string, visited: mymat, plant: u8) -> (area := 0, fences := 0, visited_already := false) {
        visited_already := false;
        if y < 0 || x < 0 || y >= mat.count || x >= mat[0].count return;
        if mat[y][x] != plant return; // gone outside
        place := visit(visited, y, x);
        if place.*  return visited_already=true; // already been here
        place.* = true;
        area := 1;
        fences := 0;

        dirs := struct {x: int; y: int;}.[.{0,1}, .{1,0}, .{-1,0}, .{0,-1}];
        for dir : dirs {
            yy, xxx := y+dir.y, x+dir.x;
            aa, ff, already := explore_area(yy, xxx, mat, visited, plant);
            if aa == 0 && !already  fences += 1;
            area += aa;
            fences += ff;
        }
        return area, fences, visited_already;
    }

    total := 0;
    for y : 0..rang(mat.count) {
        cols := mat[y].count;
        for x : 0..rang(cols) {
            area, fences := explore_area(y, x, mat, visited, mat[y][x]);
            total += area * fences;
        }
    }
    println("totaL: %", total);
}