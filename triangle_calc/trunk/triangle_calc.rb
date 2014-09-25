#encoding: Windows-31J

def pick_num(source, prm)
  Hash[
  prm.zip(
  prm.map do |pr|
    if (answer = (source.find{|s| s[/#{pr}/] || s[/#{pr.reverse}/]}))
      answer[/\d+/].to_i
    else
      nil
    end
  end
  )
  ]
end

def solve(question)
  questions = question.split(',')
  angle = questions.grep(/\A角/)
  edge  = questions - angle

  edge_length  = pick_num(edge,  %w(AB BC CA))
  angle_degree = pick_num(angle, %w(A B C))


  # 二等辺三角形は角度が1個分かれば残りの角度は算出できる。
  if edge_length.values.compact.count == 2 &&
    edge_length.values.compact.uniq.count == 1 &&
    angle_degree.values.compact.count == 1
    top = %w(A B C).select{|e| edge_length.select{|k, v| v}.keys.all?{|k| k[/#{e}/]}}
    if angle_degree[top]
      (%w(A B C) - top).each{|a| angle_degree[a] = (180 - angle_degree[top]) / 2.0}
    else
      (%w(A B C) - top).each{|a| angle_degree[a] = angle_degree.values.compact.first}
    end
  end

  # 三角形のうち角度が2個分かっていれば残りの角度は算出できる。。
  angle_degree[angle_degree.key(nil)] = 180 - angle_degree.values.compact.inject(&:+) if angle_degree.values.compact.count == 2

  case angle_degree.values.compact.count
  when 3
    if edge_length.values.compact.uniq.count <= 1 &&
      angle_degree.values.compact.uniq.count == 1 &&
      angle_degree['A'] == 60
      'あ'
    elsif (edge_length.values.compact.count == 2 && edge_length.values.compact.uniq.count == 1) ||
      angle_degree.values.compact.uniq.count == 2
      'い'
    else
      'う'
    end
  else
    if edge_length.values.compact.count == 3
      %w(あ い う)[edge_length.values.compact.uniq.count - 1]
    elsif edge_length.values.compact.count == 2
      %w(い う)[edge_length.values.compact.uniq.count - 1]
    else
      'う'
    end
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
