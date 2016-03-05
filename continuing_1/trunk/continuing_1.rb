=begin
https://codeiq.jp/q/2706
�u1�̕��тŏ�����������v

�y�T�v�z

����2�i���ŕ\���܂��B
���̂Ƃ��A1 �̘A�Ȃ�̍ő�̒�����

F(n)

�Ə����܂��B

�Ⴆ��

�@21(10�i��) = 10101(2�i��) �Ȃ̂ŁAF(21)=1
�@45(10�i��) = 101101(2�i��) �Ȃ̂ŁAF(45)=2
�@23(10�i��) = 10111(2�i��) �Ȃ̂ŁAF(23)=3
�@504(10�i��) = 111111000(2�i��) �Ȃ̂ŁAF(504)=6

�ł��B

���āAX �� Y �Ƃ���2�̐���^���܂��B
1�ȏ�̐��� n �ɂ��āAF(n)=X �ł��� n �̂����A������������ Y �Ԗڂ̐������߂Ă��������B

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
