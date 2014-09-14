#coding: Windows-31J

class UnitsEquation
  class Formula
    def self.parse(formula, unknown='')
      sign_before = '+'
      formula.scan(/([-+]?)(\d+|#{unknown})([^-+\d#{unknown}]+)/).map do |sign, num_str, unit|
        sign = sign_before if sign.empty?
        sign_before = sign
        {sign: sign, num_str: num_str, unit: unit}
      end
    end

    def self.unit_conversion_table
      @unit_conversion_table ||= Hash[
      *File.readlines(UNIT_CONVERSION).flat_map do |equation|
        unit_nums = Hash[*equation.chomp.split('=').flat_map{|formula| parse(formula).flat_map{|un| [un[:unit], un[:num_str].to_i]}}]
        unit_nums.flat_map{|unit, scale| [unit, unit_nums.values.max / scale]}
      end
      ]
    end

    UNIT_CONVERSION = 'unit_conversion.txt'
  end

  attr_reader :equ, :ans

  def initialize(equ, unknown)
    @equ = equ
    @unknown = unknown
  end

  def solve
    left_formula, right_formula = @equ.split('=')

    unit_nums_formula = Formula.parse(left_formula, @unknown) + Formula.parse(right_formula, @unknown).map{|r| r[:sign] = (r[:sign] == '-' ? '+' : '-'); r}

    unknown = unit_nums_formula.find{|un| un[:num_str] == @unknown}
    unit_nums_formula.delete(unknown)

    minimum_unit_nums = unit_nums_formula.map do |unit_num|
      num = unit_num[:num_str].to_i
      num = -num if unit_num[:sign] == unknown[:sign]
      num * Formula.unit_conversion_table[unit_num[:unit]]
    end

    @ans = minimum_unit_nums.inject(&:+) / Formula.unit_conversion_table[unknown[:unit]]
  end
end



if $0 == __FILE__
  ARGF.each do |line|
    no, *equ = line.chomp.split("\t")
    equation = equ.map{|e| UnitsEquation.new(e, '□')}
    equation.each{|e| e.solve}
    if equation.map(&:ans).uniq.size == 1
      puts "#{no}: Correct."
    else
      puts "#{no}: Wrong."
      puts equation.map{|e| "  equation: #{e.equ}, answer: #{e.ans}"}
    end
  end
end
