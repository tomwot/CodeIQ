y=[]
z=0
(2*n=gets.to_i).times{
  y=[y.map{z+=1}]+y.transpose.reverse
}
puts y.map{|w|["%#{z.to_s.size}d"]*n*' '%w}
