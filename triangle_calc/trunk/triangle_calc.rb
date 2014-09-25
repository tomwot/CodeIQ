#encoding: Windows-31J

def pick_num(source, prm)
  prm.map do |pr|
    if (answer = (source.find{|s| s[/#{pr}/] || s[/#{pr.reverse}/]}))
      answer[/\d+/].to_f
    else
      nil
    end
  end
end

def solve(question)
  questions = question.split(',')
  angle = questions.grep(/\A�p/)
  edge  = questions - angle

  edge_length  = pick_num(edge,  %w(AB BC CA))
  angle_degree = pick_num(angle, %w(A B C))


  # �񓙕ӎO�p�`�͊p�x��1������Ύc��̊p�x�͎Z�o�ł���B
  if edge_length.compact.count >= 2 &&
    edge_length.compact.count - edge_length.compact.uniq.count == 1 &&
    angle_degree.compact.count == 1
    top = (edge_length.index{|i| edge_length.count(i) == 1} - 1) % 2
    if angle_degree[top]
      angle_degree.each_index{|i| angle_degree[i] = (180.0 - angle_degree[top]) / 2.0 unless i == top}
    else
      angle_degree.each_index{|i| angle_degree[i] = angle_degree.compact.first unless i == top}
    end
  end

  # �O�p�`�̂����p�x��2�������Ă���Ύc��̊p�x�͎Z�o�ł���B�B
  angle_degree[angle_degree.index(nil)] = 180.0 - angle_degree.compact.inject(&:+) if angle_degree.compact.count == 2


  if angle_degree.compact.count == 3
    %w(�� �� ��)[angle_degree.compact.uniq.count - 1]
  elsif edge_length.compact.count == 3
    %w(�� �� ��)[edge_length.compact.uniq.count - 1]
  elsif edge_length.compact.count == 2
    %w(�� ��)[edge_length.compact.uniq.count - 1]
  else
    '��'
  end

end


if $0 == __FILE__
  answer = ARGF.map do |line|
    no, question, expect = line.chomp.split("\t")
    fact = solve(question)
    if fact == expect
      puts "#{no}: Correct."
    else
      puts "#{no}: Wrong."
      puts "  question: #{question} , expect: #{expect}, fact: #{fact}"
      no
    end
  end
  puts
  puts "answer:"
  puts answer.compact.join(',')
end
