# https://codeiq.jp/challenge/3048
# 「ダブルテトロミノ」

tetrominos_sources = {
    I: [[1, 1, 1, 1]],
    L: [[1, 1, 1], [1, 0, 0]],
    O: [[1, 1], [1, 1]],
    S: [[1, 1, 0], [0, 1, 1]],
    T: [[1, 1, 1], [0, 1, 0]],
}

tetrominos = tetrominos_sources.map do |k, v|
    [
        k,
        [v, v.reverse].flat_map do |vv|
          4.times.map{vv = vv.transpose.reverse}
        end.uniq.map do |part|
          part_xy = part.flat_map.with_index do |bit, y|
            (0...bit.size).select{|x| bit[x] == 1}.map{|x| [x, y]}
          end
          part_xy.map{|z, w| [z - part_xy[0][0], w]}
        end
    ]
  end


def solve(question, tetrominos, answer)
  return [answer] if question.empty?

  offset_x, offset_y = question.min_by{|x, y| [y, x]}

  answer1 = []
  tetrominos.each do |char, positions|
    positions.each do |position|
      position_offset = position.map{|x, y| [x + offset_x, y + offset_y]}
      answer1 += solve(question - position_offset, tetrominos, [*answer, char]) if position_offset & question == position_offset
    end
  end

  answer1
end


ARGF.each do |line|
  question = line.split.map{|pos| pos.chars.map(&:to_i)}
  answer = solve(question, tetrominos, [])
  result = if answer.empty?
             '-'
           else
             answer.uniq.map{|ans| ans.sort.join}.sort.join(',')
           end
  puts result
end
