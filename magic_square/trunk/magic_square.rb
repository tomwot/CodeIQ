# n*n魔方陣作成スクリプト。
# 探索して一番最初に見つかった物を出力する。
# 基本的な手順（1～n**2の数を使用した魔方陣の作成と出力）：
# 1. s = MagicSquare.new(n)
# 2. s.make
# 3. puts s.table
# 以下オプション（総和をずらす）
# 4. puts s.change_sum(sum)

require "pry"

class MagicSquare
  def initialize(n)
    @n = n
    @table = Array.new(@n**2)
  end

  def make
    source = (0..@n**2+1).to_a
    source[0] = nil

    index_table = (0..@n**2).to_a
    index_table_diag = Array.new(@n){|ind| (@n + 1) * ind} + Array.new(@n){|ind| ind * @n + @n - ind - 1}
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
    sum_current1 = @table[i*@n, @n]
    sum_current2 = @table.values_at(*(0...@n).map{|n| n*@n+j})
    sum_current3 = table.map.with_index{|row, i| row[i]}
    sum_current4 = table.map.with_index{|row, i| row[@n-i-1]}

    if ((sum_current1.compact.inject(&:+) > sum) ||
      (sum_current2.compact.inject(&:+) > sum) ||
      (sum_current3.any? && sum_current3.compact.inject(&:+) > sum) ||
      (sum_current4.any? && sum_current4.compact.inject(&:+) > sum))
      false
    elsif ((sum_current1.all? && sum_current1.inject(&:+) < sum) ||
      (sum_current2.all? && sum_current2.inject(&:+) < sum) ||
      (sum_current3.all? && sum_current3.inject(&:+) < sum) ||
      (sum_current4.all? && sum_current4.inject(&:+) < sum))
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
