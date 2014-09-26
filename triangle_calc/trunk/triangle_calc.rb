#encoding: Windows-31J

# CodeIQ�F�u���w��������F���O�p�`�H�񓙕ӁH�v
# https://codeiq.jp/ace/nabetani_takenori/q1097

# �^����ꂽ��������O�p�`�̎�ނ𓚂���B
# ���w�����Ȃ̂ŗ]���藝�͖������{���͈Ⴄ��ނ̎O�p�`�ɕ��ނ����\������B
# �����܂ł͍l�����Ȃ��B

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
  angle_cond = questions.grep(/\A�p/)
  edge_cond  = questions - angle_cond

  angle = pick_num(angle_cond, %w(A  B  C))
  edge  = pick_num(edge_cond,  %w(BC CA AB))


  # 3�ӂ̒�������������ΐ��O�p�`�ł���B
  angle.each_index{|i| angle[i] = 60.0} if edge.uniq.count == 1 && edge.first

  # �񓙕ӎO�p�`�͊p�x��1��������������Ȃ��Ă��c��̊p�x���Z�o�ł���B
  if edge.count(nil) <= 1 && edge.uniq.count == 2 && angle.compact.count == 1
    top = edge.index{|i| edge.count(i) == 1}
    if angle[top]
      angle.each_index{|i| angle[i] = (180.0 - angle[top]) / 2 unless i == top}
    else
      angle.each_index{|i| angle[i] = angle.compact.first unless i == top}
    end
  end

  # �s���Ȋp�x��1�����ł���΂��̊p�x�͎Z�o�ł���B
  angle[angle.index(nil)] = 180.0 - angle.compact.inject(&:+) if angle.count(nil) == 1


  if angle.all?
    %w(_ �� �� ��)[angle.uniq.count]
  elsif edge.count(nil) <= 1
    %w(_ _  �� ��)[edge.uniq.count]
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
