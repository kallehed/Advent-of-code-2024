// For more information see https://aka.ms/fsharp-console-apps
open System

open System.Numerics

let numReplace (x:bigint):(bigint list) = 
    if x = bigint 0 then [bigint 1] else 
    let strx = string x in
        if (strx.Length &&& 1) = 0 then 
                [bigint.Parse strx[0..strx.Length / 2 - 1]; bigint.Parse strx[strx.Length/2..strx.Length-1]]
        else 
            [x * (bigint 2024)]

let nums = stdin.ReadLine() 
            |> _.Split(' ')
            |> Array.map bigint.Parse
            |> Array.toList

// f should be like itself, but with possibility of memoization or whatever
let after_n_blinks f (n , num) = 
    match n with 
    | 0 -> (bigint 1)
    | _ -> 
        let two_or = numReplace num
        match two_or with 
        | [a;b] -> (f ((n-1), a)) + (f ((n-1), b))
        | [a]   -> (f ((n-1), a))
        | _ -> (bigint 0)

let memi f = 
    let dict = new System.Collections.Generic.Dictionary<_,bigint>();
    let rec g inp =
        match dict.TryGetValue(inp) with
        | (true, v) -> v 
        | _ -> 
            let temp = f g inp
            dict.Add(inp, temp)
            temp
    g

let asd = memi after_n_blinks

let nums2 = nums |> List.map (fun x -> asd (25, x)) |> List.sum

printf "result p1: %A\n" (nums2)

let nums3 = nums |> List.map (fun x -> asd (75, x)) |> List.sum

printf "\n"
printf "result p3: %A\n" (nums3)