# https://codeiq.jp/q/2024
# バスの料金を計算しよう(初級編)

CUSTOMERS = %w( A C I )

fees_str, customers_str = gets.chomp.split(':')
fees = fees_str.split(',').map(&:to_i)
customers_all = customers_str.split(',')
customers = Hash[*CUSTOMERS.map{|c| [c.to_sym, customers_all.count(c)]}.flatten(1)]

puts fees.inject(0){|sum, fee|
       sum + fee * customers[:A] + (fee/20.0).ceil * 10 * (customers[:C] + [0, customers[:I] - customers[:A] * 2].max)
     }
