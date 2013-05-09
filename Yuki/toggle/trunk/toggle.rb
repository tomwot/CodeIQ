switch = (ARGV[0] || 10).to_i

mask = 2**switch - 1
answer = []

(2**(switch-1)).times{|n| answer << (gray = n ^ (n >> 1)) << (gray ^ mask)}
answer << answer.shift
answer.each{|ans| printf "%0*b\n", switch, ans}
