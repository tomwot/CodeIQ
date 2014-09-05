#coding: Shift_JIS

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
    formula.scan(/([-+]?)(\d+|□)([^-+\d□]+)/).map do |unit_num_str|
      unit_num_str[0] = sign if unit_num_str[0].empty?
      sign = unit_num_str[0]
      unit_num_str
    end
  end

  def minimum_unit_multiple(unit)
    @@unit_conversion_table ||= Hash[
    *File.readlines(UNIT_CONVERSION).flat_map do |equation|
      unit_nums = equation.chomp.split('=').map{|formula| parse(formula).flat_map{|un| [un[2], un[1].to_i]}}
      unit_nums.flat_map{|un| un[1] = unit_nums.transpose[1].max / un[1]; un}
    end
    ]
    @@unit_conversion_table[unit] || fail("Can't find unit(#{unit}) in #{UNIT_CONVERSION}")
  end

  UNIT_CONVERSION = 'unit_conversion.txt'
end




ARGF.each do |line|
  no, *equ = line.chomp.split("\t")
  equation = equ.map{|e| Equation.new(e)}
  equation.each{|e| e.solve}
  if equation.map(&:ans).uniq.size == 1
    puts "#{no}: Correct."
  else
    puts "#{no}: Wrong."
    puts equation.map{|e| "equation = #{e.equ}, answer = #{e.ans}"}
  end
end
