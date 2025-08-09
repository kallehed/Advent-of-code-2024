
#import "Basic";
#import "File";

TY :: s32;
EMPTY_SENTINEL :TY: -1;

main :: () {

    in, ok := read_entire_file("data.txt");
    if !ok  {print("failed to read file!\n"); return;}

    print("I got this input: %\n", in);


    db : [..]TY;
    
    {
        alt := false;
        id := 0;
        for c : in {
            alt = !alt;

            length := c - #char "0";
            if alt {
                for 1..length  array_add(*db, xx id);
                id += 1;
            }
            else for 1..length  array_add(*db, EMPTY_SENTINEL);
        }
    }
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
    //print_db(db);
    move_around(*db);
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

move_around :: (db: *[..]TY) {

    b := 0;

    e := db.count - 1;

    move_e :: () #expand {
        while (db.*[e] == EMPTY_SENTINEL) {
            if (e == 0) {break; }
            e -= 1;
        }
    }

    while true {
        move_e();
        if (b >= e) break;
        if db.*[b] == EMPTY_SENTINEL {
            // move end here
            db.*[b] = db.*[e];
            db.*[e] = EMPTY_SENTINEL;
            e -= 1;
        }
        b += 1;
    }
}