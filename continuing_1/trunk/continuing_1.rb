=begin
https://codeiq.jp/q/2706
「1の並びで小さい方から」

【概要】

数を2進数で表します。
このとき、1 の連なりの最大の長さを

F(n)

と書きます。

例えば

　21(10進数) = 10101(2進数) なので、F(21)=1
　45(10進数) = 101101(2進数) なので、F(45)=2
　23(10進数) = 10111(2進数) なので、F(23)=3
　504(10進数) = 111111000(2進数) なので、F(504)=6

です。

さて、X と Y という2つの数を与えます。
1以上の整数 n について、F(n)=X である n のうち、小さい方から Y 番目の数を求めてください。

=end


def generate(x, y, order, buffer)
  return buffer.sort if order == 0

  answer = buffer.map{|buff| buff + '0'}.select{|buff| buff.split('0').map(&:size).max == x || order > x} +
           buffer.map{|buff| buff + '1'}.select{|buff| buff.split('0').map(&:size).max == x || buff.length - ('0' + buff).rindex('0') < x}
  generate(x, y, order - 1, answer)
end


x, y = gets.chomp.split(',').map(&:to_i)

iter = 0
order = x - 1
answer = [nil]
loop do
  answer += generate(x, y, order, ['1'])
  break if answer[y]
  order += 1
end

puts answer[y].to_i(2)
