
# CodeIQ：「Color Spaceを変換しよう」
# https://codeiq.jp/ace/cielavenir/q1041

# Color Space を Base Space に変換する。

color_space_code_table = [['A', [0, 1, 2, 3]], ['C', [1, 0, 3, 2]], ['G', [2, 3, 0, 1]], ['T', [3, 2, 1, 0]]]
color_space_table = Hash[
color_space_code_table.map{|base, table| [base, table.map{|t| color_space_code_table[t][0]}]}
]


ARGF.each_slice(2).each do |id, color_space_string|
  color_space = color_space_string.chomp.chars
  latest_base = color_space.shift
  base_space = [latest_base] + color_space.map{|c| latest_base = color_space_table[latest_base][c.to_i]}

  puts id
  puts base_space.join
end
