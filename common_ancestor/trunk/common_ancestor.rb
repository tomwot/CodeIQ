puts gets.split(',').map{|n|a=[];m=n.to_i;a<<(m=(m+1+(m-1)/5)/3)while m>1;a}.inject(&:&).max||?-
