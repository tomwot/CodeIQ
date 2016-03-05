x = 3
1.upto(1000) do |n|
  a = n.to_s(2).split('').map(&:to_i).chunk(&:odd?).map{|odd, ary| ary.size}
  puts "#{n},#{n.to_s(2)},#{a.inspect}" if n.to_s(2).split('').map(&:to_i).chunk(&:odd?).select{|odd, ary| odd}.map{|odd, ary| ary.size}.max == x
end
