import kotlin.math.abs

fun goodNums(nums: List<Int>): Boolean {
    if (nums.size <= 1) return true; // safe
    if (nums[0] == nums[1]) return false; // bad
    val inc: Boolean = nums[0] < nums[1];

    val isgood = { x: List<Int> ->
        x.windowed(size = 2, step = 1).all { it[0] != it[1] && it[0] < it[1] == inc && abs(it[0] - it[1]) <= 3 }
    };
    return isgood(nums);
}

fun doLine(): Boolean? {
    val line: String = readlnOrNull() ?: return null;
    val str_nums: List<String> = line.split(' ');
    val nums: List<Int> = str_nums.map { it.toInt() };

    if (goodNums(nums)) return true;

    // try removing each index, they are so small so this is fast
    for (i in 0..<nums.size) {
        var copy = nums.toMutableList();
        copy.removeAt(i);
        if (goodNums(copy)) return true;
    }
    return false;
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
