t = Enumerator.new{|y|
  n = 0
  loop {
    m = (n+=1)
    m /= 3 while m >= 3 && m % 3 != 2
    y << n if m < 2
  }
}
puts t.take(100)
