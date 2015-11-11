n,h,w,*e=readlines
N,H,W=[n,h,w].map(&:to_i)
f=e.map(&:chop).join.split('')
d=[-1,0,1]
N.times{f=f.map.with_index{|b,i|((c=d.product(d).count{|z,w|f[(i+z)%W+((i/W+w)%H)*W]==?*})==3||b==?*&&c==4)? ?*:?.}}
puts f.each_slice(W).map(&:join)
