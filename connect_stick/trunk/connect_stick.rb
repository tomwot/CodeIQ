# https://codeiq.jp/challenge/1618
# ƒzƒŠƒGƒ‚ƒ“–â‘è

USE_NUM = 3

total_length, total_num, *sticks = ARGF.readlines.map(&:to_i)

sorted_sticks = sticks.sort

sticks_next2 = {}
sticks_prev2 = {}
sorted_sticks.each_cons(2){|s1, s2| sticks_next2[s1] = sticks_prev2[s2] = s1 + s2}

min_short_stick = total_length - sticks_prev2[sorted_sticks.last]
short_sticks = sorted_sticks.drop_while{|ss| ss < min_short_stick}.each_cons(USE_NUM).take_while{|ss| ss.inject(&:+) <= total_length}.map(&:first)

min_long_index = sorted_sticks.index(short_sticks.last) + USE_NUM - 2
long_sticks = sorted_sticks[min_long_index..-1]

answer = short_sticks.map do |short|
  long2 = total_length - short
  max_long_stick = total_length - sticks_next2[short]

  max_long_index = long_sticks.rindex{|long| long <= max_long_stick} + 1
  long_sticks.slice!(max_long_index..-1)

  long_sticks.drop_while{|long| sticks_prev2[long] < long2}.count{|long| sticks_prev2[long2 - long]}
end

puts answer.inject(&:+)
