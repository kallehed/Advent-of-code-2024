package main

import (
	"fmt"
	"io"
	"log"
	"os"
)

const (
	Air = iota
	Wall
)

type Sp = uint8

var parseMap = map[byte]Sp{
	'.': Air,
	'#': Wall,
}

func CloneMap[K comparable, V any](src map[K]V) map[K]V {
	dst := make(map[K]V, len(src))
	for k, v := range src {
		dst[k] = v
	}
	return dst
}

func main() {
	b, err := io.ReadAll(os.Stdin)
	if err != nil {
		log.Fatalf("reading stdin: %v", err)
	}

	matrix := [][]Sp{{}}

	i, j := 0, 0
	pi, pj := 0, 0

	for _, b := range b {
		v, ok := parseMap[b]
		if ok {
			matrix[len(matrix)-1] = append(matrix[len(matrix)-1], v)
		} else {
			switch b {
			case '^':
				matrix[len(matrix)-1] = append(matrix[len(matrix)-1], Air)
				// place player here
				pi, pj = i, j
			case '\n':
				matrix = append(matrix, []Sp{})
				i++
				j = 0
				continue
			default:
				panic(b)
			}
		}
		j++
	}
	startpi, startpj := pi, pj
	i_len := len(matrix)
	j_len := len(matrix[0])
	outside := func(i int, j int) bool {
		return i < 0 || j < 0 || i >= i_len || j >= j_len
	}

	// move
	dir := 0
	inc_dir := func() {
		dir++
		if dir > 3 {
			dir = 0
		}
	}
	seen := make(map[struct{ a, b int }]struct{})
	for {
		// set current pos as been-here
		seen[struct{ a, b int }{pi, pj}] = struct{}{}
		mi, mj := 0, 0
		switch dir {
		case 0:
			mi = -1
		case 1:
			mj = 1
		case 2:
			mi = 1
		case 3:
			mj = -1
		default:
			panic("oops bad dir!")
		}
		npi, npj := pi+mi, pj+mj
		if outside(npi, npj) {
			// we are outside, break
			break
		}
		if matrix[npi][npj] == Wall {
			// can't walk there, change dir
			inc_dir()
			continue
		}
		pi, pj = npi, npj
	}
	fmt.Println("p1", len(seen))

	forevers := 0

	p1_seen := CloneMap(seen)

	// p2
	// for each of the positions (except start) that the guard walked on, we want to place an obstruction and see if he loops
	for k := range p1_seen {
		i, j := k.a, k.b
		if i == startpi && j == startpj {
			continue
		}
		matrix[i][j] = Wall
		pi, pj = startpi, startpj
		{
			// move
			dir := 0
			inc_dir := func() {
				dir++
				if dir > 3 {
					dir = 0
				}
			}
			broke := false
			for range 100000 {
				// set current pos as been-here
				mi, mj := 0, 0
				switch dir {
				case 0:
					mi = -1
				case 1:
					mj = 1
				case 2:
					mi = 1
				case 3:
					mj = -1
				default:
					panic("oops bad dir!")
				}
				npi, npj := pi+mi, pj+mj
				if outside(npi, npj) {
					// we are outside, break
					broke = true
					break
				}
				if matrix[npi][npj] == Wall {
					// can't walk there, change dir
					inc_dir()
					continue
				}
				pi, pj = npi, npj
			}
			if !broke {
				// foreverloop
				forevers++
			}
		}
		matrix[i][j] = Air
	}
	fmt.Println("p2: ", forevers)
}
