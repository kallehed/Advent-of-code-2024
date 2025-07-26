import kotlin.math.abs

fun doLine(): Boolean? {
    val line: String = readlnOrNull() ?: return null;
    val str_nums: List<String> = line.split(' ');
    val nums: List<Int> = str_nums.map { it.toInt() };

    if (nums.size <= 1) return true; // safe
    if (nums[0] == nums[1]) return false; // bad

    val inc: Boolean = nums[0] < nums[1];

    // iterate through and make sure everyone follows the rule
    return nums.windowed(size = 2, step = 1)
        .all { it[0] != it[1] && it[0] < it[1] == inc && abs(it[0] - it[1]) <= 3 };
}

fun main() {
    var safe = 0;
    while (true) {
        val res = doLine() ?: break;
        println(if (res) "safe" else "unsafe")
        safe += if (res) 1 else 0;
    }
    println("res $safe");
}