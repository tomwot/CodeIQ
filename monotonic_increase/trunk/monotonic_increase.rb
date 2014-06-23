require 'pry'

def divide(n)
  question = [[0, n]]

  memo = Hash.new{0}
  loop do
    answer = []
    question.each do |q|
      next if memo[q.last] > q.count
      before, last = q[-2..-1]
      before.to_s.length.upto(last.to_s.length / 2) do |digit|
        now  = last.to_s[0...digit].to_i
        rest = last.to_s[digit..-1].to_i
        if before < now && now < rest && last.to_s[digit] != '0'
          add = [*q[0..-2], now, rest]
          answer << add
          memo[rest] = add.size
        end
      end
    end

    break if answer.empty?

    question = answer.dup
  end

  question.map{|q| q[1..-1]}
end


$stdout.sync = true

ARGF.each do |line|
  no, input, expect_output = line.split(' ').map(&:to_i)
  answers = divide(input)
  max_count = answers.first.count
  if expect_output == max_count
    puts "#{no}: Correct."
  else
    puts "#{no}: Wrong. input=#{input}, expect=#{expect_output}, result=#{max_count}, max_divide=#{answers}"
  end
end
