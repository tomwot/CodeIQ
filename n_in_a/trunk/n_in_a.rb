
# CodeIQ：「中学入試から：数字の個数」
# https://codeiq.jp/ace/nabetani_takenori/q1138



def solve2(n, object)
  m = n.to_s.split('')
  (0 ... m.size).map do |digit|
    x = m[0...digit].to_a.join.to_i
    y = 10**(m.size - 1 - digit)
    if m[digit].to_i > object
      (x + (object > 0 && digit < m.size-1 ? 1 : 0)) * y + (digit == m.size-1 ? 1 : 0)
    elsif m[digit].to_i == object
      (x - (object == 0 && digit < m.size-1 ? 1 : 0)) * y + m[(digit+1)...m.size].to_a.join.to_i + 1
    else
      x * y
    end
  end.inject(&:+)
end


def solve(from, to, object)
  solve2(to, object) - solve2(from - 1, object)
end



answer = []
$stdout.sync = true

ARGF.each do |line|
  id, question, expect = line.chomp.split("\t")
  estimate = solve(*question.split(',').map(&:to_i))
  if estimate == expect.to_i
    puts "#{id}: Correct."
  else
    puts "#{id}: Wrong."
    puts "  question: #{question} , expect: #{expect}, estimate: #{estimate}"
    answer << id
  end
end
puts
puts "answer:"
puts answer.join(',')
