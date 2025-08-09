
#import "Basic";
#import "File";

TY :: s16;
EMPTY_SENTINEL :TY: -1;

print_db :: (db : [..]TY) {
    // print out the db
    for d : db {
        if d == EMPTY_SENTINEL {
            print(".");
        }
        else {
            print("%", d);
        }
    }
    print("\n");
}

main :: () {

    in, ok := read_entire_file("data.txt");
    if !ok  {print("failed to read file!\n"); return;}

    print("I got this input: %\n", in);


    db : [..]TY;
    
    highest_id := 0;
    {
        alt := false;
        id := 0;
        for c : in {
            alt = !alt;

            length := c - #char "0";
            if alt {
                for 1..length  array_add(*db, xx id);
                highest_id = id;
                id += 1;
            }
            else for 1..length  array_add(*db, EMPTY_SENTINEL);
        }
    }
    print("highest id: %\n", highest_id);
    //print_db(db);
    move_around(*db, highest_id);
    //print_db(db);

    // get checksum
    {
        total := 0;
        for d, idx : db {
            if d != EMPTY_SENTINEL  total += idx * d;
            
        }
        print("total: %\n", total);
    }
}

move_around :: (db: *[..]TY, highest_id: s64) {
    e := db.count - 1;

    id := highest_id;
    while id >= 0 {
        //print("id : %\n", id);
        //print_db(db.*);
        // find id
        while (db.data[e] != id) e -= 1;
        // we are at the id, see how long it is
        len := 0;
        while (e >= 0 && db.data[e] == id) {e -= 1; len += 1;}
        // are now before it, so go back to it 
        e += 1;

        // find free space that fits it, that is before 'e'

        b := 0;
        while b < e {
            // find empty sentinel
            while (db.data[b] != EMPTY_SENTINEL) b += 1;
            if (b >= e) break;
            // count length
            b_len := 0;
            while (db.data[b] == EMPTY_SENTINEL) {b += 1; b_len += 1;}
            if (b_len >= len) {
                // good to go, move it here
                b -= b_len;
                for 1..len {
                    db.data[b] = db.data[e];
                    db.data[e] = EMPTY_SENTINEL;
                    b += 1; e += 1;
                }
                break;
            }
        }
        // inc id for e
        id -= 1;
    }
}