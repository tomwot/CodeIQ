#coding: Windows-31J

class Equation
  attr_reader :equ, :ans

  def initialize(equ)
    @equ = equ
  end

  def solve
    left_str, right_str = @equ.split('=')

    unit_nums_str = parse(left_str) + parse(right_str).map{|r| r[0] = (r[0] == '-' ? '+' : '-'); r}

    unknown = unit_nums_str.find{|un| un[1] == '□'}
    unit_nums_str.delete(unknown)

    minimum_unit_nums = unit_nums_str.map do |sign, num_str, unit|
      num = num_str.to_i
      num = -num if sign == unknown[0]
      num * minimum_unit_multiple(unit)
    end

    @ans = minimum_unit_nums.inject(&:+) / minimum_unit_multiple(unknown[2])
  end

  private

  def parse(formula)
    sign = '+'
    formula.scan(/([-+]?)(\d+|□)([^-+\d□]+)/).map do |unit_num_arr|
      unit_num_arr[0] = sign if unit_num_arr[0].empty?
      sign = unit_num_arr[0]
      unit_num_arr
    end
  end

  def minimum_unit_multiple(unit)
    @@hash ||= Hash[
    *DATA.flat_map do |equation|
      unit_nums = equation.chomp.split('=').map{|formula| parse(formula).flat_map{|un| [un[2], un[1].to_i]}}
      unit_nums.flat_map{|uns| uns[1] = unit_nums.last[1] / uns[1]; uns}
    end
    ]
    fail "Can't find unit(#{unit}) in unit table" unless @@hash.key?(unit)
    @@hash[unit]
  end
end




ARGF.each do |line|
  no, *equ = line.chomp.split("\t")
  equation = equ.map{|e| Equation.new(e)}
  equation.each{|e| e.solve}
  if equation.all?{|e| e.ans == equation.first.ans}
    puts "#{no}: Correct."
  else
    puts "#{no}: Wrong."
    puts equation.map{|e| "equation = #{e.equ}, answer = #{e.ans}"}
  end
end


__END__
1km=1000m=100000cm=1000000mm
1kg=1000g=1000000mg
1日=24時間=1440分=86400秒
