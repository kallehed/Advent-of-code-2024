import scala.io.StdIn.readLine

@main def hello() = 
  var truth = Map[String,Int]()

  try while true do
    val Array(name, v) = readLine() split ": "
    truth += name -> v.toInt
  catch case _ => 0

  var to_compute = Array[(String, String, String, String)]()

  try while true do 
    val Array(expr,res) = readLine() split " -> "
    val Array(l, op, r) = expr split " "
    to_compute :+= (l,op,r,res)
  catch case _ => 0

  for i <- 1 to 50 do
    for (l,op,r,res) <- to_compute 
      if truth contains l 
      if truth contains r
      if !(truth contains res)
    do 
    truth += res -> (op match 
      case "AND" => truth(l) & truth(r)
      case "OR" =>  truth(l) | truth(r)
      case "XOR" => truth(l) ^ truth(r))

  var e: Long = 1 // damn, numbers are 32-bit by default...
  var total: Long = 0
  for i <- 0 to 99 do 
    val s =  "z" + (if i < 10 then "0" else "") + i.toString
    if truth contains s then total += e * truth(s)
    e *= 2
  println(s"p1 total: $total ")

  // compute the correct z
  var x_num: Long = 0
  var y_num: Long = 0

  e = 1 // damn, numbers are 32-bit by default...
  for i <- 0 to 99 do 
    val x_s =  "x" + (if i < 10 then "0" else "") + i.toString
    val y_s =  "x" + (if i < 10 then "0" else "") + i.toString
    if truth contains x_s then x_num += e * truth(x_s)
    if truth contains y_s then y_num += e * truth(y_s)
    e *= 2

  var correct_z: Long = x_num + y_num
//  println(s"bad_____z: ${total.toBinaryString}")
  //println(s"correct_z: ${correct_z.toBinaryString}")

  // ripple carry adder: z5 = z4_carry XOR (x5 XOR y5 )
  // z4_overflow = (x4 AND y4) OR ()
  //
  //z03 = () XOR (((OR ) AND (x02 XOR y02)) OR (x02 AND y02))
  // OK I solved this by just visualizing it and finding the incorrect wires manually
