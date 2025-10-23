
locks_and_keys = STDIN.read.split "\n\n"

locks, keys = [], []

locks_and_keys.each {|block| 
  lines = block.split "\n"
  nums = lines.map(&:chars).transpose.map{_1.count "#"}
  (lines[0][0] == "#" ? locks : keys) << nums
}
puts "Result p1:", locks.product(keys).count{_1.zip(_2).all?{|a,b|a+b<8}}
