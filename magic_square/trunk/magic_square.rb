require "pry"

class MagicSquare
  attr_reader :table

  def initialize(n)
    @n = n
    @table = Array.new(@n){Array.new(@n, 0)}
  end

  def make
    source = Array.new(@n**2 + 1, false)
    
    sum = (1..(@n**2)).inject(&:+) / @n

    i = 0
    last_j = -1
    loop do
      while (0...@n).cover?(i)
        row = @table[i]
        j = last_j+1

        while (0...@n).cover?(j)
          source[row[j]] = false
          x = source.index.with_index{|s, si| !s && si > row[j]}
          if x
            row[j] = source[x] = x
            if j < @n-1 && row.inject(&:+) < sum || j == @n-1 && row.inject(&:+) == sum
              j += 1
              next
            end
          end
#binding.pry
          source[row[j]] = false
          if row.inject(&:+) > sum || row[j] == @n**2  || source[(row[j]+1)..source.size].all?
            row[j] = 0
            j -= 1
          end
        end
#binding.pry
        if j == @n
          i += 1
        else
          i -= 1
          last_j = @n-2
        end
      end
#      binding.pry
      fail "Not Found." if i < 0
      if @table.transpose.all?{|row| row.inject(&:+) == sum}
        if @table.map.with_index{|row, i| row[i]}.inject(&:+) == sum && @table.map.with_index{|row, i| row[@n-i-1]}.inject(&:+) == sum
          break
        end
      end
      i -= 1
      last_j = @n-2
    end
  end

  def change_sum(sum)
    if @n.odd?
      center = (@n**2 + 1) / 2
      @table.map{|row| row.map{|cell| cell - center + sum}}
    else
      center1 = @n**2 + 1
      @table.map{|row| row.map{|cell| cell*2 - center1 + sum}}
    end
  end

end

square = MagicSquare.new((ARGV[0] || 3).to_i)
square.make
puts square.table.map{|row| row.join(' ')}
puts
puts square.change_sum(0).map{|row| row.join(' ')}

