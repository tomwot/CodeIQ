# 工夫：
# ARGF.each 以降を簡単にするために、準備に手間を掛けました。
#
# 感想：
# 盤面を反転させる必要が在る事になかなか気付かなかったです。

# https://codeiq.jp/q/1904
# テトロミノの置き方を数えよう

BOARD_SIZE = 8

POLYOMINOS = {
    I: [[1, 1, 1, 1]],
    L: [[1, 1, 1], [1, 0, 0]],
    O: [[1, 1], [1, 1]],
    S: [[1, 1, 0], [0, 1, 1]],
    T: [[1, 1, 1], [0, 1, 0]],
}

polyominos_code = {}
POLYOMINOS.each do |name, unit|
  all_shapes = []

  4.times do
    unit = unit.transpose
    all_shapes << unit
    unit = unit.reverse
    all_shapes << unit
  end

  polyominos_code[name] =
      all_shapes.uniq.map do |shape|
        base = shape.map.with_index { |s, i| s.join.to_i(2) * 1<<(BOARD_SIZE * i) }.inject(&:+)
        (0..(BOARD_SIZE - shape.first.size)).map{ |x| (0..(BOARD_SIZE - shape.size)).map{ |y| base * (2**x) * (2**BOARD_SIZE)**y } }
      end.flatten
end


ARGF.each do |line|
  answers = Hash.new(0)

  board = ~line.gsub(/\s/){}.to_i(BOARD_SIZE * 2)

  polyominos_code.each do |name, codes|
    answers[name] = codes.count { |code| board & code == code }
  end

  puts %i( I L O S T ).map{ |name| answers[name] }.join(',')
end
