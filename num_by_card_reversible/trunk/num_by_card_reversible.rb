def solve(n, m, cards, x)
  return [(m - x).abs, [x]] if n < 0

  current_cards = cards.dup
  current_cards.delete_if{|_, c| c == 0} if x == 0 && n > 0

  higher = current_cards.find_index{|_, c| x + c * 10**n <= m}
  lower  = current_cards.find_index{|_, c| x + c * 10**n + 10**n - 1 <= m}
  index = if higher.nil?
            [current_cards.size - 1]
          elsif lower == 0
            [0]
          else
            lower = current_cards.size - 1 if lower.nil?
            higher -= 1 if higher > 0
            [*higher..lower]
          end

  distance = 99999999
  answer = []
  index.each do |i|
    next_cards = cards.dup
    used_card, used_number = next_cards[i]
    next_cards.delete_if{|num, _| num == used_card}
    dist, ans = solve(n - 1, m, next_cards, x + used_number * 10**n)
    if dist < distance
      distance = dist
      answer = ans
      break if distance == 0
    elsif dist == distance
      answer += ans
    end
  end

  [distance, answer]
end

ARGF.each do |line|
  n, m, *cards_pair = line.split(/[,\/]/).map(&:to_i)
  cards = cards_pair.flat_map.with_index{|c, i| [i, i].zip(c.divmod 10)}.sort_by(&:last).reverse
  if m > 0 && cards.map(&:last).uniq == [0]
    puts '-'
  else
    puts solve(n - 1, m, cards, 0).last.uniq.sort.join(',')
  end
end
