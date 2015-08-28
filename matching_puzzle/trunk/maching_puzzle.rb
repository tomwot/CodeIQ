# https://codeiq.jp/q/1682
# プログラマーのためのパズルを解いて

m, n = gets.chomp.split.map(&:to_i)

pieces = ARGF.map{|line| line.chomp.split}
