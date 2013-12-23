=begin

Fibo{b} =
  a[0]=1,
  a[1]=B,
  a[i]=a[i-1]+a[i-2] if 2≦i

ある Fibo{B} に m と n が含まれていて、m ≦ n となっている場合、m を n の約フィボナッチ数 と呼びます。
x の約フィボナッチ数であり、y の約フィボナッチ数でもある数のうち、最も大きなものを「x と y の最大公約フィボナッチ数」と呼び、GCFibo( x, y ) と書きます。

=end

# Fibo{B}のうち n 以下の値を持つ数列
def fibo_n(b, n)
  a = [1, b]
  c = 0
  a << c while (c = a[-2] + a[-1]) <= n
  a
end

# 「約フィボナッチ数」
def divFibo(n)
  (1..n).map{|b| fibo_n(b, n)}.select{|f| f.include?(n)}.flatten.sort.uniq
end

# 「公約フィボナッチ数」
def cFibo(a, b)
  divFibo(a) & divFibo(b)
end

# 「最大公約フィボナッチ数」
def gcFibo(a, b)
  cFibo(a, b).max
end


[[23, 25], [308, 320], [6168, 9877], [18518, 19942]].each do |x, y|
  puts "gcFibo( #{x}, #{y} ) = #{gcFibo( x, y )}"
end
