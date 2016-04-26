# https://codeiq.jp/q/2801
# 「今週のお題：最短で当たるビンゴゲーム」

CARD_SIZE = 5

cards = ARGF.map{|card| card.split(',').map(&:to_i).each_slice(CARD_SIZE).map(&:to_a)}

N_PLAYERS = cards.size

lines = cards.map do |card|
  [
      card,
      card.transpose,
      [CARD_SIZE.times.map{|n| card[n][n]}],
      [CARD_SIZE.times.map{|n| card[n][CARD_SIZE-n-1]}],
  ].flatten(1)
end


def solve(n, lines, last, min)
  if n < 0
    return last, last.size
  end

  answer = [last].product(lines[n]).map{|ans| ans.flatten.uniq}.map do |ans|
    if ans.size > min
      nil
    else
      an, mini = *solve(n - 1, lines, ans, min)
      min = [min, mini].min
      an
    end
  end.flatten(n.zero? ? 0 : n-1)
  [answer, min]
end


answer, min = solve(N_PLAYERS - 1, lines, [], N_PLAYERS * CARD_SIZE)
p min
p answer.compact.select{|ans| ans.size == min}.map(&:sort)
