def parts2(n)
  sqrt2 = Math.sqrt(n.to_i)
  if sqrt2.to_i.to_f == sqrt2
    sqrt = sqrt2.to_i.to_s
  else
    sqrt = nil
  end
  pow2 = (n.to_i ** 2).to_s

  [sqrt, pow2]
end


def parts1(num)
  return [["", ""]] if num.empty?

  ret = []

  1.upto(num.size) do |len|
    n = num[0, len]
    m = num[len, num.size]
    sqrt, pow2 = parts2(n)
    parts1(m).each do |a, s|
      if sqrt
        ret << [sqrt + a, "(#{n})#{s}"] unless n == '1' || n[0] == '0'
      end
      ret << [pow2 + a, "[#{n}]#{s}"] unless n == '1' || n[0] == '0'
      ret << [n + a, "#{n}#{s}"]
    end
  end

  ret

end


seireki, heisei = ARGV

File.open("iter0.txt", "w"){|fp| fp.puts [seireki, seireki].join(',')}

ans = []
used = {}
tree = {}

used[seireki] = true

iter = 0
begin
  puts "iter:#{iter += 1}"
  ret = []
  cache = {}
  File.open("iter#{iter}.txt", "w+") do |output|
    File.open("iter#{iter-1}.txt", "r") do |input|
      input.each do |line|
        seq1 = line.chomp.split(/,/)
        dat = []
        parts1(seq1[0]).each do |add|
          unless used[add[0]]
            cache[add[0]] = true
            output.puts add.join(',')
            ans << add if add[0] == heisei
          end
        end
      end
    end
  end

  used.merge!(cache)

end while ans.empty?

iter1 = iter
answer = ans.map do |nu, st|
  iter = iter1
  an = [nu]
  begin
    an.unshift(st)
    sttr = st.tr('()[]', '')
    File.open("iter#{iter-=1}.txt", "r") do |log|
      log.each do |line|
        val, str = line.chomp.split(',')
        if sttr == val
          st = str
          break
        end
      end
    end
  end while iter > 0
  an
end

min = answer.uniq.map{|seq| seq.join.count('([])')}.min
ans_body = answer.uniq.select{|seq| seq.join.count('([])') == min}

puts
ans_body.each{|ab| puts ab.join('->')}
