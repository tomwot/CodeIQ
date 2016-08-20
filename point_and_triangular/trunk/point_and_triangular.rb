# 「三角形と点の関係」
# https://codeiq.jp/challenge/2943

def relation_polygon_and_point(points, point)
  points << points[0] unless points.first == points.last
  lines = points.each_cons(2).map{|a, b| [b[1] - a[1], a[0] - b[0], -a[0] * b[1] + a[1] * b[0]]}
  lines.map{|line| line.zip([*point, 1]).map{|a, b| a * b}.inject(:+) <=> 0}
end

answer = ARGF.map do |line|
  line.chomp.split.map do |question|
    points = question.scan(/\d+/).map(&:to_i).each_slice(2).to_a

    # 三角形内部の代表点
    g = points[0..-2].transpose.map{|xy| Rational(xy.inject(:+), 3)}

    rel_plgn_g = relation_polygon_and_point(points[0..2], g)
    rel_plgn_p = relation_polygon_and_point(points[0..2], points.last)

    if points[0..-2].member?(points.last)
      ?C
    elsif rel_plgn_g == rel_plgn_p
      ?A
    elsif rel_plgn_g.zip(rel_plgn_p).any?{|a, b| a * b == -1}
      ?D
    else
      ?B
    end
  end.join
end

puts answer
