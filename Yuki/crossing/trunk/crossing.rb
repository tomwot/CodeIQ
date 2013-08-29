start = Time.now

n = 0
nodes = []
ARGF.each_with_index do |nd, i|
  node  = nd.to_i
  idx = i + 1
  nodes[node] = true
  if node == idx
    n += nodes[(idx+1)..nodes.size].compact.size * 2
  else
    n += (node - idx).abs
  end
end

puts n / 2

puts "Time: #{Time.now - start}"
