a, b = gets.split('+').map{|n| n.scan(/\d/).map(&:to_i)}
c, d = [a, b].map{|n| n.reverse.inject{|m, x| x + 1/m.to_r}}
sum = c + d
answer = []
until sum == sum.to_i
  answer << sum.to_i
  sum = 1/(sum - sum.to_i)
end
answer << sum.to_i
if answer.length == 1
  puts answer[0]
else
  puts "[#{answer[0]};#{answer[1..-1].join(',')}]"
end