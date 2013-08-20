start = Time.now

crossing = Array.new(314160, 0)

n = ARGF.inject(0) do |sum, nod|
  node = nod.to_i
  count = crossing[node]
  1.upto(node){|n| crossing[n] += 1}
  sum + count
end

puts n

puts "Time: #{Time.now - start}"
