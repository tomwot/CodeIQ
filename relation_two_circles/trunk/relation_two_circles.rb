# https://codeiq.jp/q/2785
# 「２つの円の位置関係」

X, Y, R = 0, 1, 2

questions = ARGF.gets.chomp.split

answers = questions.map do |q|
  circles_str = []
  q.split('/').each_with_index{|c, i| _, *circles_str[i] = *c.match(/\((\d+),(\d+)\)(\d+)/)}
  circles = circles_str.map{|c| c.map(&:to_i)}

  dist_center = (circles[0][X] - circles[1][X])**2 + (circles[0][Y] - circles[1][Y])**2
  r = circles.map{|c| c[R]}

  if dist_center == 0 && r[0] == r[1]
    :A
  elsif dist_center < (r[1] - r[0])**2
    :B
  elsif dist_center == (r[1] - r[0])**2
    :C
  elsif dist_center < (r[0] + r[1])**2
    :D
  elsif dist_center == (r[0] + r[1])**2
    :E
  elsif dist_center > (r[0] + r[1])**2
    :F
  else
    raise 'Error'
  end
end

puts answers.join
