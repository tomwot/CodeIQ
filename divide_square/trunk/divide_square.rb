=begin
正方形があります。
正方形の頂点と、辺の三等分点を全部合わせて「注目点」と呼びます。
注目点のうちのひとつを別の注目点と結んだ線分で、正方形を分割する、という操作を2回行います。

このとき、出来る図形が何角形になるのかを計算して下さい。
=end

# 注目点の数値表現
edges_square = 4.times.map{|n| 4.times.map{|l| (n * 3 + l) % 12}}

ARGF.each do |line|
  # 記号を数値化する。
  edges_special = line.chomp.split.map{|l| l.chars.sort.map{|c| c.ord - ?a.ord}}.uniq.sort
  # 注目点を結んだ線分が正方形の辺と重なる場合は考慮不要なので無いものとする。
  edges_special = edges_special.delete_if{|eg_sp| edges_square.any?{|eg_sq| eg_sp.all?{|egsp| eg_sq.member?(egsp)}}}

  answer = case edges_special.count
             when 0
               [4]

             when 1
               es = edges_special.first
               if es.all?{|po| po % 3 == 0}
                 [3, 3] # 対角線
               elsif es.any?{|po| po % 3 == 0}
                 [3, 4] # 片方の端点が頂点に重なる
               elsif es.map{|po| edges_square.index{|e| e.member?(po)}}.inject(:-) == -2
                 [4, 4] # 両方の端点が頂点と重ならず、かつ端点が対向する辺の上にある
               else
                 [3, 5]
               end

             when 2
               vectors = Array.new(13){[]}
               case edges_special.transpose.map{|e| e.inject(:-)}.inject(:*) <=> 0
                 when 1 # 注目点を結んだ線分が正方形の中で交差する
                   5.times.each_cons(2) do |to, from|
                     vectors[edges_special[from % 2][from % 4 / 2]] << [-1, edges_special[to % 2][to % 4 / 2]]
                   end

                 when 0 # 注目点を結んだ線分が正方形の辺の上で交差する
                   cross = edges_special.inject(&:&)[0]
                   point = edges_special.flatten.delete_if{|e| e == cross}.sort
                   point2 = (cross.between?(*point) ? point : point.reverse)

                   vectors[point2[0]] << [-1, point2[1]]
                   vectors[cross] << [point2[0]]
                   vectors[point2[1]] << [cross]

                 when -1 # 注目点を結んだ線分が正方形の中で交差しない
                   edges_special.each do |e|
                     [e, e.reverse].each do |from, to|
                       vectors[from] << [to]
                     end
                   end

                 else
                   raise
               end

               from = 0
               to = 1
               begin
                 to += 1 until !vectors[to].empty? || to % 3 == 0
                 vectors[from] << [to % 12]
                 from = to
                 to = from + 1
               end until from == 12

               vectors.map.with_index do |vector, i|
                 next if vector.empty?
                 point_current = i
                 edge_before = :special
                 v = []
                 begin
                   point_next = (edge_before == :edge ? vectors[point_current].first : vectors[point_current].last)
                   edge_next = (edge_before == :edge && vectors[point_current].count > 1 ? :special : :edge)
                   v += point_next
                   point_current = point_next.last
                   edge_before = edge_next
                 end until point_current == i
                 v
               end.compact.uniq{|v| v.rotate(v.index(v.min))}.map(&:count)

             else
               raise
           end

  puts answer.sort.join(?,)
end
