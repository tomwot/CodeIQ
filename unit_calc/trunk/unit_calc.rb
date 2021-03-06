#coding: Windows-31J

# 単位付1元1次方程式を解く。

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
    left_formula, right_formula = @equation.split('=').map{|formula| Formula.new(formula, @unknown).parse}
    unit_nums = left_formula + right_formula.map{|r| r[:sign] = (r[:sign] == '-' ? '+' : '-'); r}

    # 方程式の中で単位が換算出来ない場合の処理
    # return unless unit_nums.uniq{|un| UNIT_CONVERSION_TABLE[un[:unit]][:base_unit]}.size == 1

    unknown = unit_nums.find{|un| un[:num_str] == @unknown}
    unit_nums.delete(unknown)

    minimum_unit_nums = unit_nums.map do |unit_num|
      num = unit_num[:num_str].to_i
      num = -num if unit_num[:sign] == unknown[:sign]
      num * UNIT_CONVERSION_TABLE[unit_num[:unit]][:scale]
    end

    @answer = minimum_unit_nums.inject(&:+) / UNIT_CONVERSION_TABLE[unknown[:unit]][:scale]
  end

  UNIT_CONVERSION_TABLE =
  DATA.map(&:chomp).each_with_object({}) do |equation, memo|
    unit_nums = equation.split('=').each_with_object({}) do |formula, mm|
      Formula.new(formula).parse.each{|f| mm[f[:unit]] = f[:num_str].to_i}
    end
    base_unit, base_unit_scale = unit_nums.max_by{|unit, scale| scale}
    unit_nums.each{|unit, scale| memo[unit] = {scale: base_unit_scale / scale, base_unit: base_unit}}
  end
  UNIT_CONVERSION_TABLE.default = {base_unit: :base_unit}

end



if $0 == __FILE__
  ARGF.each do |line|
    no, *equ = line.chomp.split("\t")
    equation = equ.map{|e| UnitsEquation.new(e, '□')}
    equation.each{|e| e.solve}
    if equation.uniq(&:answer).size == 1
      puts "#{no}: Correct."
    else
      puts "#{no}: Wrong."
      puts equation.map{|e| "  equation: #{e.equation}, answer: #{e.answer}"}
    end
  end
end

__END__
1km=1000m=100000cm=1000000mm
1kg=1000g=1000000mg
1日=24時間=1440分=86400秒
