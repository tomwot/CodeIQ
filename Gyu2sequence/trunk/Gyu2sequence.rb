# https://codeiq.jp/challenge/3194
# 「ぎゅうぎゅうシーケンス」

object = *1..3
object_index = Array.new(object.count){[]}

n = gets
gets.chars.each_with_index { |s, i| object_index[s.to_i]<<i}
min = object.min_by{|o| object_index[o].count}

object_index[min].each do |oim|

end