y=[]
z=1
1.upto(2*n=gets.to_i){|x|
  y=[(z...z+=x/2).to_a]+y.transpose.reverse
}
puts y.map{|w|["%#{"#{n*n}".size}d"]*n*' '%w}
