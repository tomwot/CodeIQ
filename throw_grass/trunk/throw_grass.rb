n=7
x=0
y=0
answer = ((0...n).to_a.repeated_permutation(2).to_a-[[x,y]]).select{|a, b| (b-y).gcd(a-x) == 1}
puts answer.count, answer.inspect
