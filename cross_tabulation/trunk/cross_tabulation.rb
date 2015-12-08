# https://codeiq.jp/q/2211
# 「Excelなら簡単な集計」

max_min   = -10
max_max   =  40
max_width =   5

min_min   = -10
min_max   =  40
min_width =   5


def headers(min, max, width, str)
  (0..((max - min) / width)).map{|n| n * width + min}.each_cons(2).map{|a, b| "#{a}<=#{str}<#{b}"}
end


table = Array.new((max_max - max_min) / max_width){Array.new((min_max - min_min) / min_width, 0)}

gets
ARGF.each do |line|
  date, *temperature = line.chomp.split(',')
  max, min = temperature.map(&:to_f)
  table[(max - max_min) / max_width][(min - min_min) / min_width] += 1
end

column_headers = headers(min_min, min_max, min_width, 'min')
row_headers    = headers(max_min, max_max, max_width, 'max')

puts [nil, *column_headers].join(',')
puts row_headers.zip(table).map{|row| row.join(',')}
