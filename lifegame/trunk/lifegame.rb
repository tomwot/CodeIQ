# https://codeiq.jp/q/2407
# 【コードゴルフ】シンプル・ライフゲーム

n, h, w, *field_source = readlines
field = field_source.map{|f| f.chop.split('').map{|c| c == '*'}}
N, H, W = [n, h, w].map(&:to_i)
N.times do |nn|
  new_field = field.map.with_index do |line, y|
    line.map.with_index do |c, x|
      count = ((((y-1)..(y+1)).to_a.product(((x-1)..(x+1)).to_a)) - [[y, x]]).count do |yy, xx|
        yy = 0 if yy == H
        xx = 0 if xx == W
        field[yy][xx]
      end
      count == 3 || c && count == 2
    end
  end
  field = new_field
end
puts field.map{|l| l.map{|c| c ? '*' : '.'}.join}
