# https://codeiq.jp/q/2786
# 「円と線分の関係」

questions = ARGF.gets.chomp.split

answers = questions.map do |q|
  _, *prms = *q.match(/\((\d+),(\d+)\)(\d+)\/\((\d+),(\d+)\)\((\d+),(\d+)\)/)
  circle_X, circle_Y, circle_R, line_X1, line_Y1, line_X2, line_Y2 = prms.map(&:to_i)

  # 円と線分の端点との関係
  rel_circle_point = ->(x, y){(x - circle_X)**2 + (y - circle_Y)**2 - circle_R**2}
  rel_circle_point1 = rel_circle_point.call(line_X1, line_Y1)
  rel_circle_point2 = rel_circle_point.call(line_X2, line_Y2)

  # 円から線分に下ろした垂線と点との関係
  rel_vertical_point = ->(x, y){(line_X2 - line_X1) * (x - circle_X) + (line_Y2 - line_Y1) * (y - circle_Y)}
  rel_vertical_point1 = rel_vertical_point.call(line_X1, line_Y1)
  rel_vertical_point2 = rel_vertical_point.call(line_X2, line_Y2)

  # 円から直線への垂線の長さの2乗
  vertical_length =
      Rational(((line_Y2 - line_Y1) * circle_X - (line_X2 - line_X1) * circle_Y + line_Y1 * (line_X2 - line_X1) - line_X1 * (line_Y2 - line_Y1))**2,
               (line_Y2 - line_Y1)**2 + (line_X2 - line_X1)**2)

  if rel_circle_point1 < 0  && rel_circle_point2 < 0
    :A
  elsif rel_circle_point1 == 0  && rel_circle_point2 == 0
    :C
  elsif rel_circle_point1 <= 0  && rel_circle_point2 <= 0
    :B
  elsif ((rel_circle_point1 == 0 && rel_circle_point2 > 0) || (rel_circle_point1 > 0 && rel_circle_point2 == 0)) &&
      rel_vertical_point1 * rel_vertical_point2 < 0
    :D
  elsif ((rel_circle_point1 == 0 && rel_circle_point2 > 0) || (rel_circle_point1 > 0 && rel_circle_point2 == 0)) &&
      rel_vertical_point1 * rel_vertical_point2 >= 0
    :G
  elsif rel_circle_point1 > 0 && rel_circle_point2 > 0 && vertical_length < circle_R**2
    :E
  elsif rel_circle_point1 * rel_circle_point2 < 0
    :F
  elsif rel_vertical_point1 * rel_vertical_point2 < 0 && vertical_length == circle_R**2
    :H
  elsif rel_circle_point1 > 0 && rel_circle_point2 > 0
    :I
  else
    raise 'Error'
  end
end

puts answers.join
