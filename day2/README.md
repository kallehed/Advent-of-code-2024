run with
`kotlinc p1.kt && kotlin P1Kt.class < data.txt`
and
`kotlinc p2.kt && kotlin P2Kt.class < data.txt`



Notebook for kotlin: 
```kt

strings.filter { it.length == 5 }.sortedBy { it }.map { it.uppercase() }



listOf

elvis infix operator: ?:, get something else if null.  
?. operator (monad maybe thing, but with null. )

map:   val users = mapOf(1 to user1, 2 to user2, 3 to user3)



fun main() {
    val medals: List<String> = listOf("Gold", "Silver", "Bronze")
    val reversedLongUppercaseMedals: List<String> =
        medals
            .map { it.uppercase() }
            .also { println(it) }
            // [GOLD, SILVER, BRONZE]
            .filter { it.length > 4 }
            .also { println(it) }
            // [SILVER, BRONZE]
            .reversed()
    println(reversedLongUppercaseMedals)
    // [BRONZE, SILVER]
}

fun printObjectType(obj: Any) {
    when (obj) {
        is Int -> println("It's an Integer with value $obj")
        !is Double -> println("It's NOT a Double")
        else -> println("Unknown type")
    }
}

fun calculateTotalStringLength(items: List<Any>): Int {
    return items.sumOf { (it as? String)?.length ?: 0 }
}

.filterNotNull()  // Filter nulls

```