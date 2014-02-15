n = 0
b = []
begin
  m = (n+=1)
  m /= 3 while m >= 3 && m % 3 != 2
  b << n if m < 2
end until b.size == 100
puts b
