// The Swift Programming Language
// https://docs.swift.org/swift-book
//

@main
struct day17 {
    static func main() {
        print("Hello, \(334 + 34) world!strusct")
        part1()
    }
}

func part2_alt(inp _: UInt8) {
    let len = 16
    let arr = [2, 4, 1, 3, 7, 5, 4, 7, 0, 3, 1, 5, 5, 5, 3, 0]
    assert(arr.count == len)
    var A_count: UInt64 = 0 // we are faster than prev solution

    next_a: while true {
        if A_count & ((1 << 30) - 1) == 0 {
            print("\(A_count)")
        }
        var A: UInt64 = A_count
        let A_start = A
        A_count += (1 << 0)
        var B: UInt64 = 0
        var C: UInt64 = 0
        // Program:
        // 2,4,
        // 1,3,
        // 7,5,
        // 4,7,
        // 0,3,
        // 1,5,
        // 5,5,
        // 3,0
        var idx = 0
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 2 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 4 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 1 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 3 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 7 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 5 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 4 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 7 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 0 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 3 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 1 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 5 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 5 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 5 { continue next_a }
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 3 { continue next_a }
        print("GOT TO \(idx), with A: \(A_start)")
        idx += 1
        B = A & 7
        B = B ^ 3
        C = A >> B
        B = B ^ C
        A = A >> 3
        B = B ^ 5
        if B & 7 != 0 { continue next_a }
        // reached end
        print("corrrect A is \(A_start)")
        return
    }
}

func part1() {
    var (A, B, C, arr) = parse()
    // part2(A, B, C, copy arr);

    var ip = 0

    func combo_get(_ arg: Int) -> Int {
        switch arg {
        case 0 ... 3: arg
        case 4: A
        case 5: B
        case 6: C
        case 7: fatalError("bad num 7")
        default: fatalError("bad num not 7")
        }
    }

    func deal_with(_ opcode: Int, _ arg: Int) {
        switch opcode {
        case 0:
            A = A / (1 << combo_get(arg))
        case 1:
            B = B ^ arg
        case 2:
            B = combo_get(arg) & 7
        case 3:
            if A != 0 {
                ip = arg
                return
            }
        case 4:
            B = B ^ C
        case 5:
            print("\(combo_get(arg) % 8),", terminator: "")
        case 6:
            B = A / (1 << combo_get(arg))
        case 7:
            C = A / (1 << combo_get(arg))
        default: fatalError("bad opcode")
        }
        ip += 2
    }
    print("start running... PART1: copy paste the following line except the last comma!")
    while true {
        if ip >= arr.count {
            break
        }
        let op = arr[ip]
        let arg = arr[ip + 1]
        deal_with(op, arg)
    }
    part2_alt(inp: 0)
}

func parse() -> (A: Int, B: Int, C: Int, [Int]) {
    let a = readLine()!
    let b = readLine()!
    let c = readLine()!
    _ = readLine()!
    let end = readLine()!

    // Register A: 52884621
    // Program: 2,4,1,3,7,5,4,7,0,3,1,5,5,5,3,0

    let aa = Int(a.suffix(from: a.lastIndex(of: " ")!).dropFirst(1))!
    let bb = Int(b.suffix(from: b.lastIndex(of: " ")!).dropFirst(1))!
    let cc = Int(c.suffix(from: c.lastIndex(of: " ")!).dropFirst(1))!

    var eend = end.dropFirst(9)
    var arr: [Int] = []
    repeat {
        let optInd = eend.firstIndex(of: ",")
        let num = eend[..<(optInd ?? eend.endIndex)]
        let nnum = Int(num)!
        arr = arr + [nnum]
        let e = if let _ = optInd { true } else { false }
        if !e { break }
        eend = eend.suffix(from: optInd!).dropFirst(1)
    } while true
    print("got this: \(aa), \(bb), \(cc), \(arr)")

    return (aa, bb, cc, arr)
}
