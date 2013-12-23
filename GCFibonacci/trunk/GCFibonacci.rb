=begin

Fibo{b} =
  a[0]=1,
  a[1]=B,
  a[i]=a[i-1]+a[i-2] if 2��i

���� Fibo{B} �� m �� n ���܂܂�Ă��āAm �� n �ƂȂ��Ă���ꍇ�Am �� n �̖�t�B�{�i�b�`�� �ƌĂт܂��B
x �̖�t�B�{�i�b�`���ł���Ay �̖�t�B�{�i�b�`���ł����鐔�̂����A�ł��傫�Ȃ��̂��ux �� y �̍ő����t�B�{�i�b�`���v�ƌĂсAGCFibo( x, y ) �Ə����܂��B

=end

# Fibo{B}�̂��� n �ȉ��̒l��������
def fibo_n(b, n)
  a = [1, b]
  c = 0
  a << c while (c = a[-2] + a[-1]) <= n
  a
end

# �u��t�B�{�i�b�`���v
def divFibo(n)
  (1..n).map{|b| fibo_n(b, n)}.select{|f| f.include?(n)}.flatten.sort.uniq
end

# �u����t�B�{�i�b�`���v
def cFibo(a, b)
  divFibo(a) & divFibo(b)
end

# �u�ő����t�B�{�i�b�`���v
def gcFibo(a, b)
  cFibo(a, b).max
end


[[23, 25], [308, 320], [6168, 9877], [18518, 19942]].each do |x, y|
  puts "gcFibo( #{x}, #{y} ) = #{gcFibo( x, y )}"
end
