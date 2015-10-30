# https://codeiq.jp/q/2428
# 「くねくね最短経路」
#
# 感想：
# 履歴を残すかどうかで少々悩みましたが、
# 履歴を残さない方がすっきり書けました。


SIZE = 6
DIRECTIONS = %i( north south east west )
INCREMENT = {north: -SIZE, south: +SIZE, east: +1, west: -1}

memo = Array.new(SIZE**2){{}}

SIZE.times do |size|
  memo[size][:north]           = true
  memo[-1 - size][:south]      = true
  memo[SIZE * size][:west]     = true
  memo[SIZE * size - 1][:east] = true
end

maze = gets.chomp.delete('/').chars

start = maze.index('s')
next_steps = DIRECTIONS.map{|direction| {position: start, direction: direction}}
iter = 0

begin
  last_steps = next_steps
  current_steps = last_steps.delete_if do |s|
    maze[s[:position]] == 'X' || memo[s[:position]][s[:direction]]
  end
  current_steps.each{|s| memo[s[:position]][s[:direction]] = true}
  next_steps = current_steps.flat_map do |s|
    next_position = s[:position] + INCREMENT[s[:direction]]
    (DIRECTIONS - [s[:direction]]).map do |direction|
      {position: next_position, direction: direction}
    end
  end
  iter += 1
end until next_steps.empty? || next_steps.any?{|s| maze[s[:position]] == 'g'}


puts next_steps.empty? ? 'X' : iter
