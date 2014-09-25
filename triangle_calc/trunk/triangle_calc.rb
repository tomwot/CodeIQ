#encoding: Windows-31J

def pick_num(source, prm)
  Hash[
  prm.zip(
  prm.map do |pr|
    if (answer = (source.find{|s| s[/#{pr}/] || s[/#{pr.reverse}/]}))
      answer[/\d+/].to_f
    else
      nil
    end
  end
  )
  ]
end

def solve(question)
  questions = question.split(',')
  angle = questions.grep(/\A�p/)
  edge  = questions - angle

  edge_length  = pick_num(edge,  %w(AB BC CA))
  angle_degree = pick_num(angle, %w(A B C))


  # �񓙕ӎO�p�`�͊p�x��1������Ύc��̊p�x�͎Z�o�ł���B
  if edge_length.values.compact.count >= 2 &&
    edge_length.values.compact.count - edge_length.values.compact.uniq.count == 1 &&
    angle_degree.values.compact.count == 1
    top = %w(A B C).find{|e| edge_length.select{|k, v| edge_length.values.count(v) == 2}.keys.all?{|k| k[/#{e}/]}}
    if angle_degree[top]
      %w(A B C).delete_if{|t| t == top}.each{|a| angle_degree[a] = (180.0 - angle_degree[top]) / 2.0}
    else
      %w(A B C).delete_if{|t| t == top}.each{|a| angle_degree[a] = angle_degree.values.compact.first}
    end
  end

  # �O�p�`�̂����p�x��2�������Ă���Ύc��̊p�x�͎Z�o�ł���B�B
  angle_degree[angle_degree.key(nil)] = 180 - angle_degree.values.compact.inject(&:+) if angle_degree.values.compact.count == 2


  if angle_degree.values.compact.count == 3
    %w(�� �� ��)[angle_degree.values.compact.uniq.count - 1]
  elsif edge_length.values.compact.count == 3
    %w(�� �� ��)[edge_length.values.compact.uniq.count - 1]
  elsif edge_length.values.compact.count == 2
    %w(�� ��)[edge_length.values.compact.uniq.count - 1]
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
