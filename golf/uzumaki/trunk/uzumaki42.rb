y=[[z=1]]
3.upto(2*n=gets.to_i){
  y=[y.map{z+=1}]+y.transpose.reverse
}
puts y.map{|w|["%#{z.to_s.size}d"]*n*' '%w}
