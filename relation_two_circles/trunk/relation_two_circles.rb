# https://codeiq.jp/q/2785
# 「２つの円の位置関係」

questions = ARGF.gets.chomp.split

puts questions.map do |q|
  circles_str = []
  q.split('/').each_with_index{|c, i| _, *circles_str[i] = *c.match(/\((\d+),(\d+)\)(\d)/)}
  circles = circle_str.map{|c| c.map(&:to_i)}

  case circles
    when ->(circles){circles[0] == circles[1]}
      puts 'A'
  end
end
