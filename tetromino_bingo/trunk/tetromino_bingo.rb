POLYOMINO_SIZE = 4 # ビンゴと判定するポリオミノのマス目の数
POLYOMINO_SHAPES = %w(I L S O T)


# ポリオミノの形を返す。
# 入力：ポリオミノを構成するマス目（2次元座標：整数値）
# 出力：そのポリオミノの形を表すアルファベット1文字
def detect_shape(polyomino)
  # area = ポリオミノに外接する長方形が占める領域
  area_left   = polyomino.map{|x, y| x}.min
  area_top    = polyomino.map{|x, y| y}.min
  area_right  = polyomino.map{|x, y| x}.max
  area_bottom = polyomino.map{|x, y| y}.max

  if area_right == area_left || area_bottom == area_top
    'I'
  elsif area_right - area_left == 1 && area_bottom - area_top == 1
    'O'
  elsif ([[area_left, area_top], [area_right, area_bottom], [area_left, area_bottom], [area_right, area_top]] & polyomino).size == 3
    'L'
  elsif ([[area_left, area_top], [area_right, area_bottom]] & polyomino).size == 1
    'T'
  else
    'S'
  end
end



# ここでは数値化せずに文字列のままとする。
# マス目の値が文字列 = まだ塗り潰されていないマス目
# マス目の値が数値   = 塗り潰されたマス目
numbers = ARGF.gets.chomp.split(',')

answer = Hash.new(0)

ARGF.each do |line|
  card = line.chomp.split(/[\/,]/)
  card_size = line.split('/').first.split(',').size

  shape = '-'
  numbers.each_with_index.any? do |number, idx|
    next unless (index = card.index(number))

    # 過去に振られた id とは異なる id を振る事が出来れば良いので、
    # numbers のインデックスを id として使用する。
    card[index] = idx

    neighbors = [
    (card[index]),
    (card[index - 1]         unless index % card_size == 0),
    (card[index + 1]         unless index % card_size == card_size - 1),
    (card[index - card_size] unless index / card_size == 0),
    (card[index + card_size] unless index / card_size == card_size - 1),
    ].select{|nei| nei.is_a?(Integer)} # nei.class == Fixnum でも普通は問題無い。

    next if neighbors.size == 1 # 無くても動くけど分かり易い足切りなので入れておく。

    # 塗り潰した領域が連結したら同じ id とする。
    card.each_with_index.select{|n, i| neighbors.member?(n)}.each{|n, i| card[i] = neighbors.min}

    polyomino = card.each_with_index.select{|n, i| card.count(n) == POLYOMINO_SIZE}.map{|n, i| i.divmod(card_size)}
    next if polyomino.empty?

    shape = detect_shape(polyomino)
  end

  puts "#{line.chomp} #{shape}"
  answer[shape] += 1

end

puts
puts POLYOMINO_SHAPES.sort.map{|char| "#{char}:#{answer[char]}"}.join(',')
