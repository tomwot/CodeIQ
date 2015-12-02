# https://codeiq.jp/q/2211
# 「Excelなら簡単な集計」

max_min   = -10
max_max   =  40
max_width =   5

min_min   = -10
min_max   =  40
min_width =   5

table = Array.new((max_max - max_min) / max_width){Array.new((min_max - min_min) / min_width, 0)}

gets
ARGF.each do |line|
  date, *temperature = line.chomp.split(',')
  max, min = temperature.map(&:to_f)
  table[(max - max_min) / max_width][(min - min_min) / min_width] += 1
end

column_headers = (0..((min_max - min_min) / min_width)).map{|n| n * min_width + min_min}.each_cons(2).map{|a, b| "#{a}<=min<#{b}"}

puts [nil, *column_headers].join(',')
puts table.map.with_index{|row, i| ["#{i * max_width + max_min}<=max<#{(i + 1) * max_width + max_min}" ,*row].join(',')}
