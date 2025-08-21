# Advent-of-code-2024
Trying 25 different programming languages 


## THE DAYS:
DAY1: Racket (Bad tooling, vscode ext didn't work. Felt like worse haskell)

DAY2: Kotlin (Bad tooling, only got autocomplete partially to work on intellij community edition)

DAY3: Python (Good tooling in vscode)

DAY4: Rust (VERY good tooling in vscode)

DAY5: Haskell (OK tooling, hlint is good, ormolu works)

DAY6: Go (Very good tooling, monkey-level language) 

DAY7: Ocaml (Nice tooling, but annoying stdlib, good formatter)

DAY8: C 

DAY9: Jai (Has syntax highlighting at least)

DAY10: C# (Boring language)

DAY11: F# (Pretty nice, but annoying+elusive documentation)

DAY12: Odin (Okay language, good std, but sometimes confusing) 

DAY13: Julia (Seemed interesting but I just used regex and a integer optimization library) 

### Languages to use:

```
- C++ (alt. std)                     Systemy
- Rust DONE
- Zig
- Pascal
- Odin DONE
- Fortran
- RiscV assembly
- C DONE
- Jai DONE
- C# DONE                            Garbage collected
- Kotlin DONE
- Go DONE
- Haskell DONE                       Functional
- Ocaml DONE
- F# DONE
- Racket DONE                        Lispy
- Clojure
- Julia DONE                         Interpreted
- Python DONE
- Typescript
- Lua
- Bash
- Elixir                             Erlang
- Gleam
- OpenCL                             GPU
- CUDA
- Uiuia                              Weird
- Prolog
```


# Notes
Implemented Day7 in haskell as well, haskell was actually slower

Odin has a bunch of very weird quirks. Like, should you use delete or free?
I liked the return-value stuff, setting default return values. 
Odin is good with int's. Better than rust. You can just use ints and index your slices and so on. 
But you can't index '::' arrays with runtime values... have to copy them first with ':='
I approve of fuzzy search: `https://pkg.odin-lang.org/base/`


Jai has some GREAT error messages:
```
p1.jai:1,1: Error: Unable to parse an expression here. This looks like a C-style declaration (two identifiers in a row); maybe it's a mistake of habit? If you want to declare a variable, try "p1: package;"

    package p1
```


But finding library functions in jai is a nightmare... a million "rg 'somename ::'"



GLPK: GNU Linear Programming Kit, works. 
