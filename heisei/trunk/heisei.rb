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
    next if m[0] == '0'
    sqrt, pow2 = *parts2(n)
    re = parts1(m)
    if sqrt
      re.each do |a, s|
        ret << [sqrt + a, "(#{n})#{s}"] unless n == '0' || n == '1'
      end
    end
    re.each do |a, s|
      ret << [pow2 + a, "[#{n}]#{s}"] unless n == '0' || n == '1'
      ret << [n + a, "#{n}#{s}"]
    end
  end

  ret

end


seireki, heisei = ARGV

num = [[seireki, seireki]]

output = File.open("log.txt", "w")

ans = []
used = {}
tree = {}

used[seireki] = true

iter = 0
loop do
  puts "iter:#{iter += 1}"
  ret = []
  cache = {}
  num.each do |seq1|
    dat = []
    parts1(seq1[0]).uniq.each do |add|
      unless used[add[0]]
        cache[add[0]] = true
        dat << add[1]
        ret << add.tap{|ttt| output.puts ttt.join(',')}
        ans << add.tap{|ttt| p ttt} if add[0] == heisei
      end
    end
    tree[seq1[1]] = dat
  end

  break unless ans.empty?

  used.merge!(cache)
  num = ret.sort_by{|seq| seq[0].to_i}
  output.puts

end

answer = ans.map do |nu, st|
  an = []
  begin
    an.unshift(st)
    str = ""
    tree.each do |key, val|
      if val.member?(st)
        str = key
        break
      end
    end
  end until (st = str).empty?
  an
end

min = answer.uniq.map{|seq| seq.join.count('([])')}.min
ans_body = answer.uniq.select{|seq| seq.join.count('([])') == min}

puts
ans_body.each do |ab|
  ab.shift
  puts [ab, heisei].join('->')
end
