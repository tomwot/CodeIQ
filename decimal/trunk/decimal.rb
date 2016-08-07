# https://codeiq.jp/challenge/2924
# 「変進小数の足し算」

answers = ARGF.map do |line|
  id, expression, given = line.chomp.split
  num1, num2 = expression.split(?+).map{|n| n.split(?.)}
  num1, num2 = num2, num1 if num1[1].size < num2[1].size
  sum_dec_arr = num1[1].chars.zip(num2[1].chars).map{|n1, n2| n1.to_i + n2.to_i}.reverse
  carry = 0
  sum_dec_arr.each_index do |i|
    carry, sum_dec_arr[i] = (sum_dec_arr[i] + carry).divmod(11 - sum_dec_arr.size + i)
  end

  sum_int = num1[0].to_i + num2[0].to_i + carry

  sum_dec = sum_dec_arr.reverse.join[/\A(\d*?)0*\z/, 1]

  sum = "#{sum_int}#{?. + sum_dec unless sum_dec.empty?}"

  [id, expression, given, sum] unless sum == given
end.compact

if answers.size == 0
  puts 'all of cases are correct.'
else
  puts answers.map(&:first).join(?,)
end