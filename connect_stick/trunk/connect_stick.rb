# https://codeiq.jp/challenge/1618
# ƒzƒŠƒGƒ‚ƒ“–â‘è

USE_NUM = 3

total_length, total_num, *sticks = ARGF.readlines.map(&:to_i)

sorted_sticks = sticks.sort

sticks_hash_asc  = {}
sticks_hash_desc = {}
sorted_sticks.each_cons(2) do |s1, s2|
  sticks_hash_asc[s1]  = s2
  sticks_hash_desc[s2] = s1
end

min_short_sticks = total_length - sorted_sticks[1 - USE_NUM, USE_NUM].inject(&:+)
min_short_index = sorted_sticks.find_index{|ss| ss >= min_short_sticks} || total_num
max_short_index = (min_short_index...total_num).find{|i| sorted_sticks[i, USE_NUM].inject(&:+) >= total_length} || total_num

MIN_LONG_INDEX = max_short_index + USE_NUM - 2
max_long_index = total_num - 1

answer = sorted_sticks[min_short_index..max_short_index].map do |short|
  next_short = sticks_hash_asc[short]

  min_long_stick = (total_length - short) / 2
  min_long_index = (MIN_LONG_INDEX...max_long_index).find{|long_stick_index| min_long_stick <= sorted_sticks[long_stick_index]} || max_long_index

  max_long_stick = total_length - (short + next_short)
  max_long_index = (min_long_index.succ..max_long_index).reverse_each.find{|long_stick_index| max_long_stick >= sorted_sticks[long_stick_index]} || min_long_index

  sorted_sticks[min_long_index..max_long_index].count do |long|
    middle = total_length - (short + long)
    sticks_hash_asc[middle] && next_short <= middle && middle <= sticks_hash_desc[long]
  end
end

puts answer.flatten.inject(&:+)
