run `go run . < data.txt`


example code: 
```go
func swap(x, y string) (string, string) {
	return y, x
}


for i := 0; i < 10; i++ {
		sum += i
	}

switch os := runtime.GOOS; os {
	case "darwin":
		fmt.Println("macOS.")
	case "linux":
		fmt.Println("Linux.")
	default:
		// freebsd, openbsd,
		// plan9, windows...
		fmt.Printf("%s.\n", os)
	}

    var a [2]string
	a[0] = "Hello"
	a[1] = "World"
	fmt.Println(a[0], a[1])
	fmt.Println(a)

	primes := [6]int{2, 3, 5, 7, 11, 13}


    //slice:
    s = s[2:]

  //  == nil to check for empty slice

   // make to dynalloc:
a := make([]int, 5)  // len(a)=5
//To specify a capacity, pass a third argument to make:

b := make([]int, 0, 5) // len(b)=0, cap(b)=5

b = b[:cap(b)] // len(b)=5, cap(b)=5
b = b[1:]      // len(b)=4, cap(b)=4

// append to slice:
s = append(s, 0)


// iterating lists:
pow := make([]int, 10)
for i := range pow {
    pow[i] = 1 << uint(i) // == 2**i
}
for _, value := range pow {
    fmt.Printf("%d\n", value)
}

// map
var m map[string]Vertex

func main() {
	m = make(map[string]Vertex)
	m["Bell Labs"] = Vertex{
		40.68433, -74.39967,
	}
	fmt.Println(m["Bell Labs"])
}

// pointers
package main

import "fmt"

func badfunc() *int {
    asd := 34;
    return &asd;
}

func main() {
    fmt.Println("Hello, World!")
    asd := badfunc();
    *asd += 2;
    fmt.Println("asd:",*asd);
}

```