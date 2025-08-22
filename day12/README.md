
run p1: `odin run p1.odin -file < data.txt`
run p2: `odin run p2.odin -file < data.txt`


watch it: `watch --differences -c -n 0.4 "odin run p1.odin -file  < data.txt"`

// (also in the p1.jai version, do  `watch --differences -c -n 0.4 "jai-linux p1.jai && ./p1"`)
// (also, jai has many weird bugs, like, if you put in type annotation for compile-time
// know variable it sometimes will think it's not compile-time anymore??)
// (also, it allows you to modify compile time known constants if you just
// pass them to a function, and then you can actually modify CONSTANT information... OOPS that was actually my fault, because it copies the whole array: [2]int to the function (not a pointer)
// that should probably crash instead, as it should be READONLY memory...)


// you can only index into compile-time known arrays/slices with compile time known constants??
// Had to convert a array :: []int{1,2,3} into array := ...
// (you CAN do this in jai...)

odin notes:
```

for i := 0; i < 10; i += 1 {
	fmt.println(i)
}

for i := 0; i < 10; i += 1 do single_statement()

for i in 0..<10 {
	fmt.println(i)
}
for i in 0..=9 {
	fmt.println(i)
}

some_array := [3]int{1, 4, 9}
for value in some_array { fmt.println(value) }

some_slice := []int{1, 4, 9}
for value in some_slice { fmt.println(value) }

some_dynamic_array := [dynamic]int{1, 4, 9} // must be enabled with `#+feature dynamic-literals`
defer delete(some_dynamic_array)
for value in some_dynamic_array { fmt.println(value) }

some_map := map[string]int{"A" = 1, "C" = 9, "B" = 4} // must be enabled with `#+feature dynamic-literals`
defer delete(some_map)
for key in some_map { fmt.println(key) }

//address operator in for loops:
for &value in some_slice {
	value = something
}


// reverse, also ? in array:
array := [?]int { 10, 20, 30, 40, 50 }

#reverse for x in array {
	fmt.println(x) // 50 40 30 20 10
}

// nice if syntax:
if x := foo(); x < 0 {
	fmt.println("x is negative")
}

// switch
switch arch := ODIN_ARCH; arch {
case .i386, .wasm32, .arm32:


// switch true
switch {
case x < 0:
	fmt.println("x is negative")
case x == 0:
	fmt.println("x is zero")
case:
	fmt.println("x is positive")
}

// union
Foo :: union {int, bool}
f: Foo = 123
switch _ in f {
case int:  fmt.println("int")
case bool: fmt.println("bool")
case:
}

// casting
f := cast(f64)i
// transmute
u := transmute(u32)f

// auto cast
x: f32 = 123
y: int = auto_cast x


// good unions:
Value :: union #no_nil {bool, string}

// or else:
i = m["hellope"] or_else 123

```