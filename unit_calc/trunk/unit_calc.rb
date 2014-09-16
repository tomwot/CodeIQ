#coding: Windows-31J

class UnitsEquation
  class Formula
    def initialize(formula, unknown='')
      @formula = formula
      @unknown = unknown
    end

    def parse
      sign_before = '+'
      @formula.scan(/([-+]?)(\d+|#{@unknown})([^-+\d#{@unknown}]+)/).map do |sign, num_str, unit|
        sign = sign_before if sign.empty?
        sign_before = sign
        {sign: sign, num_str: num_str, unit: unit}
      end
    end
  end

  attr_reader :equation, :answer

  def initialize(equation, unknown)
    @equation = equation
    @unknown  = unknown
  end

  def solve
    left_formula, right_formula = @equ.split('=').map{|formula| Formula.new(formula, @unknown).parse}
    unit_nums = left_formula + right_formula.map{|r| r[:sign] = (r[:sign] == '-' ? '+' : '-'); r}

    unknown = unit_nums.find{|un| un[:num_str] == @unknown}
    unit_nums.delete(unknown)

    minimum_unit_nums = unit_nums.map do |unit_num|
      num = unit_num[:num_str].to_i
      num = -num if unit_num[:sign] == unknown[:sign]
      num * @@unit_conversion_table[unit_num[:unit]]
    end

    @answer = minimum_unit_nums.inject(&:+) / @@unit_conversion_table[unknown[:unit]]
  end

  UNIT_CONVERSION = 'unit_conversion.txt'

  @@unit_conversion_table =
  File.readlines(UNIT_CONVERSION).each_with_object({}) do |equation, memo|
    unit_nums = equation.chomp.split('=').each_with_object({}) do |formula, mm|
      Formula.new(formula).parse.each{|f| mm[f[:unit]] = f[:num_str].to_i}
    end
    unit_nums.each{|unit, scale| memo[unit] = unit_nums.values.max / scale}
  end

end



if $0 == __FILE__
  ARGF.each do |line|
    no, *equ = line.chomp.split("\t")
    equation = equ.map{|e| UnitsEquation.new(e, '□')}
    equation.each{|e| e.solve}
    if equation.map(&:answer).uniq.size == 1
      puts "#{no}: Correct."
    else
      puts "#{no}: Wrong."
      puts equation.map{|e| "  equation: #{e.equation}, answer: #{e.answer}"}
    end
  end
end
