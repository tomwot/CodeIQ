#coding: Windows-31J

class Equation
  attr_reader :equ, :ans

  def initialize(equ)
    @equ = equ
  end

  def solve
    left_str, right_str = @equ.split('=')

    sign = '+'
    left = parse(left_str).map do |un|
      sign = un[0] = (un[0].empty? ? sign : un[0])
      un
    end

    sign = '+'
    right = parse(right_str).map do |un|
      sign = un[0] = (un[0].empty? ? sign : un[0])
      un[0] = (un[0] == '-' ? '+' : '-')
      un
    end

    unitnums_str = left + right
    unknown = unitnums_str.find{|un| un[1] == '□'}
    unitnums_str.delete(unknown)

    minimum_unit_nums = unitnums_str.map do |sign, num_str, unit|
      num = num_str.to_i
      num = -num if sign == unknown[0]
      num * minimum_unit_multiple(unit)
    end

    @ans = minimum_unit_nums.reduce(&:+) / minimum_unit_multiple(unknown[2])
  end

  private

  def parse(str)
    str.scan(/([-+]?)(\d+|□)([^-+\d□]+)/)
  end

  def minimum_unit_multiple(unit)
    @hash ||= Hash[
    *UNIT_NUMS_EQUATION.flat_map do |equation|
      unit_nums = equation.split('=').map{|uns| parse(uns).flat_map{|un| [un[2], un[1].to_i]}}
    unit_nums.flat_map{|uns| uns[1] = unit_nums.last[1] / uns[1]; uns}
    end
    ]
    @hash[unit]
  end

  UNIT_NUMS_EQUATION = [
    '1km=1000m=100000cm=1000000mm',
    '1kg=1000g=1000000mg',
    '1日=24時間=1440分=86400秒'
  ]
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
