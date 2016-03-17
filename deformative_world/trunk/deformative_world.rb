# https://codeiq.jp/q/2751
# 「世界は歪んでいる。それでも君は歩む。」

direction_step = {clock: [1, 0], in: [0, 1], unti_clock: [-1, 0], out: [0, -1]}
direction = direction_step.keys

map = {}
map_source = [*'0'..'9', *'a'..'z', *'A'..'Z', '@'].each_slice(3).to_a.each_slice(7).to_a
map_source.each_with_index do |block, i|
  block.each_with_index do |line, j|
    line.each_with_index do |cell, k|
      map[cell] = Hash[
          *direction_step.map do |dir, (fb, io)|
            [
                dir,
                {
                    next_position:  (block[j + fb][k + io] if (j + fb).between?(0, 6) && (k + io).between?(0, 2)),
                    next_direction: dir,
                }
            ]
          end.flatten
      ]
    end
  end
end

map_source.each_with_index do |block, i|
  block.last.each_with_index do |cell, k|
    map[cell][:clock] = {
        next_position:  map_source[(i + 1) % 3][k][2],
        next_direction: :out
    }
    map[map_source[(i + 1) % 3][k][2]][:in] = {
        next_position:  cell,
        next_direction: :unti_clock,
    }
  end
end


current_position = '0'
current_direction = :clock
footmark = [current_position]

catch do |tag|
  gets.chomp.chars do |c|
    case c
      when '0'..'9'
        c.to_i.times do
          next_pd = map[current_position][current_direction]
          current_position  = next_pd[:next_position]
          current_direction = next_pd[:next_direction]
          if current_position
            footmark << current_position
          else
            footmark << '!'
            throw tag
          end
        end
      when 'R'
        current_direction = direction[(direction.find_index(current_direction) + 1) % direction.size]
      when 'L'
        current_direction = direction[(direction.find_index(current_direction) - 1) % direction.size]
    end

  end
end

puts footmark.join
