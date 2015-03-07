proc = ->(a){1|(a-1)&10922}

(1..10000).each do |a|
  printf "%015b, %d\n",b=proc.call(a), b
end
