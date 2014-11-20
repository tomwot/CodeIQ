# CodeIQ�F�u���w��������F�}�`�Əꍇ�̐��v
# https://codeiq.jp/ace/nabetani_takenori/q1188

# �~����𓙊Ԋu�ŕ�������_�̏W�����������s�b�N�A�b�v���A
# �����̓_���牽��ނ̎O�p�`�����邩�𓚂���B
# ��]���ďd�Ȃ���͓̂���A���Ԃ��ďd�Ȃ���͕̂ʂƂ��čl����B


# #{n_pick}�p�`������ލ��邩��Ԃ��B
def solve(n_divide, points, n_pick)
  points.map{|p| ('A'..'Z').to_a.index(p)}.combination(n_pick).map{|p| p.map{|po| p.map{|poi| (poi - po) % n_divide}.sort}.min}.uniq.count
end


$stdout.sync = true

answer = []

ARGF.each do |line|
  id, n_divide, points, expect = line.chomp.split("\t")
  estimate = solve(n_divide.to_i, points.split(','), 3)
  if estimate == expect.to_i
    puts "#{id}: Correct."
  else
    puts "#{id}: Wrong."
    puts "  N: #{n_divide}, points: #{points}, expect: #{expect}, estimate: #{estimate}"
    answer << id
  end
end
puts
puts "answer:"
puts answer.join(',')

