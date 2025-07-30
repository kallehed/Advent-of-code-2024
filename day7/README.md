ocaml, both parts in p1.ml

run with:
`ocaml p1.ml < data.txt`

format with:
`ocamlformat p1.ml --inplace`


example code
```ocaml

val u : int list = [1; 2; 3; 4]

-- if:
 if "hello" = "world" then 3 else 5


-- let x in
  let a = 1 in
  let b = 2 in

` function:
let square x = x * x;;

-- anon function
fun x -> x * x;;

-- map
List.map (fun x -> x * x) [0; 1; 2; 3; 4; 5];;

-- recursive function
# let rec range lo hi =
    if lo > hi then
      []
    else
      lo :: range (lo + 1) hi;;

-- pattern matching
# let f opt = match opt with
    | None -> None
    | Some None -> None
    | Some (Some x) -> Some x;;

-- mutable state
let r = ref 0;;

-- use ! to access the state of ref
use := to assign

-- use a;b operator to first compute a and then b:
print_string !text; text := "world!"; print_endline !text;; 


-- @ to combine two lists

```