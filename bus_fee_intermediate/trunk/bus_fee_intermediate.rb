# https://codeiq.jp/q/1937
# バス代の計算(ややリアル編)

CUSTOMERS = %w( A C I )
PASS = %w( n p x )

CHILD_PARCENT = 0.5
EXTRA_PASS_PARCENT = 0.56

def calc_fees(fee)
       answer = {}

       answer[:An] = fee
       answer[:Ap] = 0
       answer[:Ax] = (fee * EXTRA_PASS_PARCENT / 10.0).ceil * 10
       answer[:Cn] = (fee * CHILD_PARCENT / 10.0).ceil * 10
       answer[:Cp] = 0
       answer[:Cx] = (answer[:Cn] * EXTRA_PASS_PARCENT / 10.0).ceil * 10
       answer[:In] = answer[:Cn]
       answer[:Ip] = answer[:Cp]
       answer[:Ix] = answer[:Cx]

       answer
end


FREE_PASS_FEE = calc_fees(910)

CUSTOMERS_KINDS = CUSTOMERS.product(PASS).map{|cus, pas| "#{cus}#{pas}".to_sym}

standard_fees_str, customers_str = gets.chomp.split(':')
standard_fees = standard_fees_str.split(',').map(&:to_i)
customers_all = customers_str.split(',')
customers = Hash[*CUSTOMERS_KINDS.map{|customer| [customer, customers_all.count(customer.to_s)]}.flatten(1)]

# 大人の人数合計
n_A = customers.select{|k, v| k[0] == 'A'}.map(&:last).inject(&:+)

# 大人と同伴扱いになる幼児（通常）の人数
n_In = [customers[:In], n_A * 2].min

# 大人と同伴扱いになる幼児（特別割引）の人数
n_Ix = [customers[:Ix], n_A * 2 - n_In].min

# 大人と同伴扱いになる幼児（定期券あり）の人数
n_Ip = 0

customers[:In] -= n_In
customers[:Ix] -= n_Ix
customers[:Ip] -= n_Ip

actual_fees = Hash.new(0)

standard_fees.each do |sfee|
  fees = calc_fees(sfee)
  CUSTOMERS_KINDS.each{|customer| actual_fees[customer] += fees[customer]}
end

puts actual_fees.map{|customer, fee| [fee, FREE_PASS_FEE[customer]].min * customers[customer]}.inject(&:+)
