# https://codeiq.jp/q/1633

# 標準入力された文字列を以下のルールで変換し、その結果を標準出力してください
# 1. 以下に列挙する順序でルールが適用される。例えば後述の 2, 3 の両方が成立する場合は 2 が優先される。
# 2. 標準入力された文字列の先頭の文字の ASCII Code が 15 で割り切れる場合は、標準入力された文字列を Capitalize する
# ※Capitalize = 先頭の文字のみ大文字、残りは全て小文字
# 3. 標準入力された文字列の先頭の文字の ASCII Code が 5 で割り切れる場合は、標準入力された文字列を 大文字化 する
# 4. 標準入力された文字列の先頭の文字の ASCII Code が 3 で割り切れる場合は、標準入力された文字列を 小文字化 する
# 5. 標準入力された文字列の先頭の文字の ASCII Code が 15, 5, 3 のいずれでも割り切れない場合、入力された文字列

ARGF.each do |line|
  puts ({
    0             => line,
    line.ord % 3  => line.downcase,
    line.ord % 5  => line.upcase,
    line.ord % 15 => line.capitalize,
  })[0]
end
