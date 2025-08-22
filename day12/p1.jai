#import "Basic";
#import "String";
os :: #import "File";

// we need @PrintLike, as the format string is checked by a metaprogram for some reason??
// (no 'compilation' of the format strings at compile time???)
println :: (x: string, y: .. Any) #expand { print(#run join(x, "\n"), ..y); } @PrintLike

// OMG why is the syntax for taking the address "*", very confusing error message when using "&"

main :: () {
    get :: () -> []string {
        data, success := os.read_entire_file("data.txt");
        if !success {
            println("Failed to read input from stdin...");
            exit(1);
        }
        return split(data, "\n");
    }

    r_mat :: #run get();

    ROWS, COLS :: r_mat.count, r_mat[0].count;

    #run println("COMPILE TIME KNOWN::: rows: %, cols: %", ROWS, COLS);

    on_type :: ($T: Type) -> Type {return [ROWS][COLS]T;}
    m_type :: #run on_type(u8);
    v_type :: #run on_type(bool);

    //mat : m_type;
    mat := New(m_type);
    defer free(mat);
    for row,i:r_mat for item,j:row  mat.data[i][j] = item;
    

    // create 'visited' bool 2darray (initialized to false, I think)
    visited : *v_type = New(v_type);
    defer free(visited);

    rang :: (x: $T) -> T #expand { return   max(x-1, 0) ;}

    bad :: (x,y) => y < 0 || x < 0 || y >= ROWS || x >= COLS;

    explore_area :: (y: int, x: int, mat: *m_type, visited: *v_type, plant: u8) -> (area := 0, fences := 0, visited_already := false) {
        visited_already := false;
        if bad(x, y) return;
        if mat.data[y][x] != plant return; // gone outside
        place := *visited.data[y][x];
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
    for y : 0..rang(ROWS) {
        for x : 0..rang(COLS) {
            area, fences := explore_area(y, x, mat, visited, mat.data[y][x]);
            total += area * fences;
        }
    }
    println("totaL: %", total);
}