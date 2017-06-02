data = ARGF.eof? ? DATA : ARGF

data.each do |line|
	init = line.chomp.chars
	towers_from = [towers: [init, [], []], prev: nil]
	n = init.count
	memo = {}
	memo[towers_from.first.map(&:join).join(?,)] = true
	iter = 0
	catch(:found) do |found|
		loop do
			iter += 1
			towers_to = []
			towers_from.each do |towers|
				towers[:towers].each_index do |i|
					next if towers[:prev] == i ||  towers[:towers][i].empty?
					towers[:towers].each_index do |j|
						next if i == j
						towers_next = towers[:towers].map{|t| t.dup}
						head = towers_next[i].shift
						towers_next[j].unshift(head)
						next if towers_next[j].each_with_index.any?{|t, k| towers_next[j][0...k].count{|tt| tt > t} == 2}
						throw found if j != 0 && towers_next[j].count == n
						next if memo[towers_next.map(&:join).join(?,)]
						towers_to << {towers: towers_next, prev: j}
						memo[towers_next.map(&:join).join(?,)] = true
					end
				end
			end
			towers_from = towers_to
		end
	end
	puts iter
end

__END__
1234
123
1314
