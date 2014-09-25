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
  angle = questions.grep(/\A角/)
  edge  = questions - angle

  edge_length  = pick_num(edge,  %w(AB BC CA))
  angle_degree = pick_num(angle, %w(A B C))


  # 二等辺三角形は角度が1個分かれば残りの角度は算出できる。
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

  # 三角形のうち角度が2個分かっていれば残りの角度は算出できる。。
  angle_degree[angle_degree.index(nil)] = 180.0 - angle_degree.compact.inject(&:+) if angle_degree.compact.count == 2


  if angle_degree.compact.count == 3
    %w(あ い う)[angle_degree.compact.uniq.count - 1]
  elsif edge_length.compact.count == 3
    %w(あ い う)[edge_length.compact.uniq.count - 1]
  elsif edge_length.compact.count == 2
    %w(い う)[edge_length.compact.uniq.count - 1]
  else
    'う'
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
