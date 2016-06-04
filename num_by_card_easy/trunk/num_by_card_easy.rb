def solve(n, m, cards, x)
  return [(m - x).abs, [x]] if n < 0

  current_cards = cards.dup
  current_cards.delete(0) if x==0 && n > 0

  higher = current_cards.find_index{|c| x + c * 10**n <= m}
  lower  = current_cards.find_index{|c| x + c * 10**n + 10**n - 1 <= m}
  index = if higher.nil?
            [current_cards.size - 1]
          elsif lower == 0
            [0]
          else
            lower = current_cards.size - 1 if lower.nil?
            higher -= 1 if higher > 0
            [*higher..lower]
          end

  ans = index.map do |i|
    next_cards = cards.dup
    next_cards.delete_at(i)
    solve(n - 1, m, next_cards, x + cards[i] * 10**n)
  end

  dist = ans.map(&:first).min
  [dist, ans.select{|a| a.first == dist}.map(&:last).flatten]
end

ARGF.each do |line|
  n, m, *cards = line.split(/[,\/]/).map(&:to_i)

  if n > 1 && cards.uniq == [0]
    puts '-'
  else
    puts solve(n - 1, m, cards.sort.reverse, 0).last.uniq.sort.join(',')
  end
end
