three = (0...100).map{|n| 3**n}
sum = three.dup
i = 1
begin
  modified = false
  three.select{|t| t < sum.last}.combination(i+=1) do |tc|
    if sum.last > (s=tc.inject(:+))
      modified = true
      sum[99] = s
      sum.sort!
    end
  end
end while modified
sum.each{|s| puts s}
