
# CodeIQ：「中学入試から：数字の個数」
# https://codeiq.jp/ace/nabetani_takenori/q1138

# AからBまでの整数の中に現れる文字 C の個数の合計を求める。

def solve2(n, object)
  div = n
  n.to_s.length.times.map do |digit|
    m = div
    div, mod = m.divmod(10)
    order = 10**digit

    if mod < object
      div * order
    elsif order == 1
      div + 1
    elsif mod > object
      (div + (object >  0 ? 1 : 0)) * order
    else # mod == object
      (div - (object == 0 ? 1 : 0)) * order + n % order + 1
    end
  end.inject(&:+)
end


def solve(from, to, object)
  solve2(to, object) - solve2(from - 1, object)
end



$stdout.sync = true

answer = []

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
