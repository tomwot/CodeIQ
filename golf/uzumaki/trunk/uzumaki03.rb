def r(a)
  a.transpose.reverse
end
x=[[1]]
3.step(n=gets.to_i,2){|a|
  x=[((b=a*a-a)+1..a*a).to_a]+r([((c=b-a+1)+1..b).to_a]+r([((d=c-a+1)+1..c).to_a]+r([(d-a+3..d).to_a]+r(x))))
}
puts x.map{|w|w.map{|s|"%#{"#{n*n}".size}d"%s}*' '}
