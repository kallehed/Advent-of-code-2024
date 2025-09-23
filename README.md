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

DAY14: C++ (Hooray 1000 line template error messages, and incomprehensible std documentation for just reading with an input iterator thingy)

DAY15: Fortran (A refreshing language, good lsp, nice documentation. Though the language is kind of weird and annoying)

DAY16: Zig (Worst language so far... opposite of 'joy of programming'. Clown language)

DAY17: Swift (Nifty language)

### Languages to use:

```
- C++ DONE                           Systemy
- Rust DONE
- Zig DONE
- Pascal
- Odin DONE
- Fortran DONE
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
- Swift DONE                         
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


For some reason Jai has pointer arithmatic, so if you have `asd: *[2]int` (pointer to an array of 2 ints), you can't do `asd[0] = 2`, because that will do it like c, it will index into the 'array' of arrays. 
This is bad and annoying, cuz you have to do `asd.*[0]` instead... Not great for refactoring! ~ Odin does this right. 

Fortran has real 1950's style, and if you can't handle it, though luck

One sad thing about jai: it doesn't have structural equivalence of structs or enums. So two struct{} declarations are never the same struct. Though if you have the name of the other struct, you can do 'cast,force(T)', basically a transmute. Jai is also weird in that, with some constructs, the first thing you assign it to, changes the thing itself. Like 'asd :: enum{};', now this enum's name is 'asd'. Same weird thing with '#import "thing"', you can bind a name to it, and then it does something different (i.e. not 'using' up all of it). I wonder why you don't write "using #import 'thing';", maybe as syntactic sugar you can just import. But it breaks the 'mathematical' properties of the language. The expressions have side effects depending on CONTEXT!

Zig handles this in another way, which is also pretty weird. ".member" are literal literals, which can be compared directly, even if no enums with that member exist. But if enums don't have structural equivalence anymore if you do: 'enum{a,}.a", because when you compare two values like that, zig complains of differing types. 


Bad things about zig: 
- super annoying integers, usize is mandatory in index iteration and indexing. Have to use @intCast, but then you sometimes have to create a new 'const' just for that result as it uses type inference for some reason...
- Bad generics, you can't introduce type parameters in the normal way (asd: $T  like Jai/Odin or <T> in rust), you have to give them as an argument to the function... This means Zig has hundreds of compiler builtins for standard math operations like @mod. Generics is only good when using methods from structs, as they 'capture' the type variable from when you created the new type. (ironic, as zig doesn't have closures) 
- no closures. Thus, a bazillion 'Context' parameters to e.g. sort. AND NO, you don't need garbage collection for closures, just look at C++. 
- Everything sucks. You can't even move a function into another function, because the syntax is different now... Need to create a struct with a single function, which you then lurk out of it... 
- Terrible compiler errors, transitive 'unused variable' errors when you try to make something compile... The compiler HATES YOU!
- No joy. Zig is for complete masochists who hate compiling. Who just want to live in a world where -WError is mandatory and you are never allowed to compile anything. 
- No good stuff like rust-style iterators. 
- Bad print function. If you spell something wrong in your format string, you aren't even informed what line of your code is wrong. Good luck writing multiple format strings at once and compiling...
- Everything about this language screams just 'unfinished mess', 'features without any thought', 'pure syntactic absurdity' ...
- ArrayList(T) is 40 bytes, as opposed to 24 in rust or C++. ('cuz allocators and so on...), I may change my mind in the future if I see good justification for this...
