#encoding: Windows-31J

# CodeIQ：「中学入試から：正三角形？二等辺？」
# https://codeiq.jp/ace/nabetani_takenori/q1097

# 与えられた条件から三角形の種類を答える。
# 中学入試なので余弦定理は無し＝本当は違う種類の三角形に分類される可能性あり。
# そこまでは考慮しない。

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
  angle_cond = questions.grep(/\A角/)
  edge_cond  = questions - angle_cond

  angle = pick_num(angle_cond, %w(A  B  C))
  edge  = pick_num(edge_cond,  %w(BC CA AB))


  # 3辺の長さが等しければ正三角形である。
  angle.each_index{|i| angle[i] = 60.0} if edge.uniq.count == 1 && edge.first

  # 二等辺三角形は角度が1個だけしか分からなくても残りの角度を算出できる。
  if edge.count(nil) <= 1 && edge.uniq.count == 2 && angle.compact.count == 1
    top = edge.index{|i| edge.count(i) == 1}
    if angle[top]
      angle.each_index{|i| angle[i] = (180.0 - angle[top]) / 2 unless i == top}
    else
      angle.each_index{|i| angle[i] = angle.compact.first unless i == top}
    end
  end

  # 不明な角度が1個だけであればその角度は算出できる。
  angle[angle.index(nil)] = 180.0 - angle.compact.inject(&:+) if angle.count(nil) == 1


  if angle.all?
    %w(_ あ い う)[angle.uniq.count]
  elsif edge.count(nil) <= 1
    %w(_ _  い う)[edge.uniq.count]
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
