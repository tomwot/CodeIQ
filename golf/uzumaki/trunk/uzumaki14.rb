x=[[[1]],2]
3.step(n=gets.to_i,2){|a|
  x=[2,1,1,0].inject(x){|(y,z),w|
    [[(z...t=z-w+a).to_a]+y.transpose.reverse,t]
  }
}
puts x[0].map{|w|w.map{|s|"%#{"#{n*n}".size}d"%s}*' '}
