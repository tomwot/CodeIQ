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

    @index = 0
    loop do
      while (0...@n**2).cover?(@index)
        old_val = (@table[@index] || (@n**2 + 1))
        source[old_val] = old_val
        new_val = source.compact.reverse_each.find{|s| s < old_val}
        if new_val
          @table[@index] = new_val
          source[new_val] = nil
          result = check?
          if result
            @index += 1
            next
          end
        end
        
        current_val = @table[@index]
        source[current_val] = current_val
        if result == nil || source[1...current_val].compact.empty?
          @table[@index] = nil
          @index -= 1
        end
      end
      
      fail "Not Found." if @index < 0
      
      break if @index == @n**2
      
      @index -= 1
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

  def check?
    i, j = @index.divmod(@n)
    sum_current1 = @table[i*@n, @n].compact.inject(&:+)
    sum_current2 = @table.values_at(*(0...@n).map{|n| n*@n+j}).compact.inject(&:+)
    sum_current3 = table.map.with_index{|row, i| row[i]}.compact.inject(&:+)
    sum_current4 = table.map.with_index{|row, i| row[@n-i-1]}.compact.inject(&:+)

    if (((j <=> @n-1) == (sum_current1 <=> sum)) &&
      ((i <=> @n-1) == (sum_current2 <=> sum)) &&
      (i     != j    || ((i <=> @n-1) == (sum_current3 <=> sum))) &&
      (i + j != @n-1 || ((i <=> @n-1) == (sum_current4 <=> sum))))
      true
    elsif (((j == @n-1) && (sum_current1 < sum)) ||
      ((i == @n-1) && (sum_current2 < sum)) ||
      (i     == j    && ((i == @n-1) && (sum_current3 < sum))) ||
      (i + j == @n-1 && ((i == @n-1) && (sum_current4 < sum))))
      nil
    else
      false
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
