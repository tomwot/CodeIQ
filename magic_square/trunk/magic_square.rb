# n*n魔方陣作成スクリプト。
# 探索して一番最初に見つかった物を出力する。
# 基本的な手順（1～n**2の数を使用した魔方陣の作成と出力）：
# 1. s = MagicSquare.new(n)
# 2. s.make
# 3. puts s.table
# 以下オプション（総和をずらす）
# 4. puts s.change_sum(sum)

class MagicSquare
  def initialize(n)
    @n = n
    @table = Array.new(@n**2)
  end

  def make
    source = (0..@n**2+1).to_a
    source[0] = nil

    index_table = (0..@n**2).to_a
    index_table_diag = Array.new(@n){|ind| (@n + 1) * ind} + Array.new(@n){|ind| (ind + 1) * (@n - 1)}
    index_table = (index_table_diag + index_table).uniq

    i = 0
    loop do
      while (0...@n**2).cover?(i)
        index = index_table[i]
        old_val = (@table[index] || @n**2 + 1)
        source[old_val] = old_val
        new_val = source.compact.reverse_each.find{|s| s < old_val}
        if new_val
          @table[index] = new_val
          source[new_val] = nil
          result = check?(index)
          if result
            i += 1
            next
          end
        end

        current_val = @table[index]
        source[current_val] = current_val
        if new_val == nil || result == nil
          @table[index] = nil
          i -= 1
        end
      end

      fail "Not Found." if i < 0

      break if i == @n**2

      fail "???"
    end
  end

  def change_sum(csum)
    if csum % @n != 0
      $stderr.puts "set argument as n*a (a = 0, 1, 2, ...)"
      return []
    end

    if @n.odd?
      center = (@n**2 + 1) / 2
      @table.map{|cell| cell - center + csum/@n}.each_slice(@n)
    else
      center1 = @n**2 + 1
      @table.map{|cell| cell*2 - center1 + csum/@n}.each_slice(@n)
    end
  end

  def table
    @table.each_slice(@n)
  end

  private

  def check?(index)
    i, j = index.divmod(@n)
    sum_current = [
    @table[i*@n, @n],                                        # horisontal
    @table.values_at(*(0...@n).map{|n| @n * n + j}),         # vertical
    @table.values_at(*(0...@n).map{|n| (@n + 1) * n}),       # back-slash
    @table.values_at(*(0...@n).map{|n| (@n - 1) * (n + 1)}), # slash
    ]

    if sum_current.any?{|s| s.compact.inject(0, &:+) > sum}
      false
    elsif sum_current.any?{|s| s.all? && s.inject(&:+) < sum}
      nil
    else
      true
    end
  end

  def sum
    @sum ||= @n * ((@n**2) + 1) / 2
  end

end


if $0 == __FILE__
  $stderr.puts start=Time.now
  $stderr.puts

  square = MagicSquare.new((ARGV[0] || 3).to_i)
  square.make
  puts square.table.map{|row| row.join(' ')}
  puts
  puts square.change_sum(0).map{|row| row.join(' ')}

  $stderr.puts
  $stderr.puts finish=Time.now
  $stderr.puts finish-start
end
