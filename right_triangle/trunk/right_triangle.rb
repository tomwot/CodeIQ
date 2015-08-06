# https://codeiq.jp/q/1722
# 直角を探せ！ 〜ピタゴラスさんありがとう〜

# 感想：
# とりあえず思い付いたものです。ゴルフするかどうかは今後のやる気次第。

x=gets.chomp.split(',')
y=x.map{|n| "#{n}.".split('.',3)[1].size}
z=x.zip(y).map{|m,n| (m.delete('.') + "0"*(y.max - n)).to_i**2}
w=(0..2).find{|t| a,b,c=z.rotate(t);a==b+c}
puts %w(A B C x)[w||3]
