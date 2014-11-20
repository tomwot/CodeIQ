# CodeIQ：「中学入試から：図形と場合の数」
# https://codeiq.jp/ace/nabetani_takenori/q1188

# 円周上を等間隔で分割する点の集合から幾つかをピックアップし、
# それらの点から何種類の三角形が作れるかを答える。
# 回転して重なるものは同一、裏返して重なるものは別として考える。


# #{n_pick}角形が何種類作れるかを返す。
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

