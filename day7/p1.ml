(* want to read *)

let parse_line : unit -> (int * int list) option =
 fun () ->
  try
    let (line : string) = read_line () in
    let two = String.split_on_char ':' line in
    match two with
    | [ (a : string); (b : string) ] ->
        let first_num = int_of_string a in
        let (rest : string list) = String.split_on_char ' ' b in
        let int_list = List.filter_map int_of_string_opt rest in
        Option.some (first_num, int_list)
    | _ -> Option.none
  with End_of_file -> Option.none

let parsed : (int * int list) list =
  let rec call_line () =
    let a_res = parse_line () in
    match a_res with Some res -> res :: call_line () | None -> []
  in
  call_line ()

(* for each item in the list, we want to find if we can replicate .0 with +,* *)

let line_works : int * int list -> bool =
 fun (res, ops) ->
  let rec helper sum elems =
    match elems with
    | h :: rest -> if helper (sum + h) rest then true else helper (sum * h) rest
    | [] -> if sum == res then true else false
  in
  helper 0 ops

let (result : bool list) = List.map line_works parsed

let end_sum =
  List.fold_left
    (fun acc x -> x + acc)
    0
    (List.map2 (fun x (num, _) -> if x then num else 0) result parsed)

let () = Printf.printf "p1: %d\n" end_sum

let line_works2 : int * int list -> bool =
 fun (res, ops) ->
  let rec helper sum elems =
    match elems with
    | h :: rest ->
        if helper (sum + h) rest then true
        else if helper (sum * h) rest then true
        else
          helper
            (int_of_string (String.cat (Int.to_string sum) (Int.to_string h)))
            rest
    | [] -> if sum == res then true else false
  in
  helper 0 ops

let (result2 : bool list) = List.map line_works2 parsed

let end_sum2 =
  List.fold_left
    (fun acc x -> x + acc)
    0
    (List.map2 (fun x (num, _) -> if x then num else 0) result2 parsed)

let () = Printf.printf "p2: %d\n" end_sum2
