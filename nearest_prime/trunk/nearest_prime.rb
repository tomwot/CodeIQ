require 'prime'

def position(n, ubound)
  if n <= ubound**2 - (ubound - 1)
    [ubound, n - (ubound - 1)**2]
  else
    [ubound**2 - n + 1, ubound]
  end
end


def distance(a, b)
  a.zip(b).map{|c, d| (d - c)**2}.inject(&:+)
end


def range(bound, position_n, min_distance)
  (((bound - 1)**2 + 1)..(bound**2)).map do |m|
    dist = distance(position_n, position(m, bound))
    [m, dist] if dist <= min_distance
  end.compact
end


def calc(range, min_distance, answer)
  range.select{|m, dist| m.prime?}.each do |prime, dist|
    if dist < min_distance
      answer = [prime]
      min_distance = dist
    elsif dist == min_distance
      answer << prime
    end
  end
  [answer, min_distance]
end

n = gets.to_i
position_n = position(n, bound = (1..1000).find{|m| n <= m**2})
answer = []
min_distance = 1000000

0.upto(999) do |diff|
  lower_range = range(bound - diff, position_n, min_distance)
  answer, min_distance = calc(lower_range, min_distance, answer)

  upper_range = range(bound + diff, position_n, min_distance)
  answer, min_distance = calc(upper_range, min_distance, answer)

  break if lower_range.empty? && upper_range.empty?
end

puts answer.sort.uniq.join(',')
