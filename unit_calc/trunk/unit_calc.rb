#coding: Windows-31J

class UnitEquation
  attr_reader :equ, :ans

  def initialize(equ)
    @equ = equ
  end

  def solve
    left_str, right_str = @equ.split('=')

    unit_nums_str = parse(left_str) + parse(right_str).map{|r| r[:sign] = (r[:sign] == '-' ? '+' : '-'); r}

    unknown = unit_nums_str.find{|un| un[:num_str] == '□'}
    unit_nums_str.delete(unknown)

    minimum_unit_nums = unit_nums_str.map do |unit_num_str|
      num = unit_num_str[:num_str].to_i
      num = -num if unit_num_str[:sign] == unknown[:sign]
      num * @@unit_conversion[unit_num_str[:unit]]
    end

    @ans = minimum_unit_nums.inject(&:+) / @@unit_conversion[unknown[:unit]]
  end

  private

  def self.parse(formula)
    sign_before = '+'
    formula.scan(/([-+]?)(\d+|□)([^-+\d□]+)/).map do |sign, num_str, unit|
      sign = sign_before if sign.empty?
      sign_before = sign
      {sign: sign, num_str: num_str, unit: unit}
    end
  end

  UNIT_CONVERSION = 'unit_conversion.txt'

  @@unit_conversion = Hash[
  *File.readlines(UNIT_CONVERSION).flat_map do |equation|
    unit_nums = equation.chomp.split('=').map{|formula| parse(formula).flat_map{|un| [un[:unit], un[:num_str].to_i]}}
    unit_nums.flat_map{|un| un[1] = unit_nums.transpose[1].max / un[1]; un}
  end
  ]

  def parse(formula)
    self.class.parse(formula)
  end
end




ARGF.each do |line|
  no, *equ = line.chomp.split("\t")
  equation = equ.map{|e| UnitEquation.new(e)}
  equation.each{|e| e.solve}
  if equation.map(&:ans).uniq.size == 1
    puts "#{no}: Correct."
  else
    puts "#{no}: Wrong."
    puts equation.map{|e| "  equation: #{e.equ}, answer: #{e.ans}"}
  end
end
