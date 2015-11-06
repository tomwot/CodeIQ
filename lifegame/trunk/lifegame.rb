n,h,w,*e=readlines
N,H,W=[n,h,w].map(&:to_i)
f=e.map{|h|h.chop.split('').map{|c|c==?*}}
d=[*-1..1]
N.times{f=f.map.with_index{|l,y|l.map.with_index{|m,x|(c=d.product(d).count{|w,z|f[(w+y)%H][(z+x)%W]})==3||m&&c==4}}}
puts f.map{|l|l.map{|c|c ? ?*:?.}*''}
