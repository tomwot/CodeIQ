# https://codeiq.jp/q/1722
# 直角を探せ！ 〜ピタゴラスさんありがとう〜

# 感想：
# とりあえず思い付いたものです。ゴルフするかどうかは今後のやる気次第。

x=gets.chomp.split(',')
y=x.map{|n|s,t,_="#{n}.".split('.',3);(s+t.ljust(4,'0')).to_i**2}
z=(0..2).find{|t| a,b,c=y.rotate(t);a==b+c}
puts %w(A B C x)[z||3]
