all = ARGF.readlines.map{|aa| aa.chomp.split(/ = /).map{|aaa| aaa.split(/ /)}}
unknown = {}

begin
  found = false

  # 左辺が（右辺も）１つだけのものを抽出
  solve_uniq = all.select{|aa| aa[0].size == 1}
  unless solve_uniq.empty?
    found = true
    solve_uniq.each{|id_uniq, name_uniq| unknown[id_uniq[0]] = name_uniq[0]}
    all.map!{|id0, name0| [id0 - unknown.keys, name0 - unknown.values]}.delete_if{|id0, name0| id0.empty?}
  end

  # all.each とすると、追加された項も含めてしまうので
  # 事前にサイズを決める。
  all_size = all.size
  all_size.times do |i|
    id1, name1 = *all[i]
    next if id1.empty?

    # 自分自身以外で共通項が最も多いものを抽出する。
    product_size = all[0...all_size].map.with_index{|(id2, name2), j| [(id1 & id2).size, j]}
    product_size.slice!(i)
    max_size, max_idx = *product_size.uniq{|size, idx| size}.sort.last
    next if max_size == 0

    found = true
    id_max, name_max = *all[max_idx]
    id_product = id1 & id_max
    name_product = name1 & name_max

    all << [id1 - id_product, name1 - name_product]
    all << [id_max - id_product, name_max - name_product]
    all << [id_product, name_product]
    all[i] = [[], []]
    all[max_idx] = [[],[]]
  end
  all.delete_if{|id3, name3| id3.empty?}

end while found

answer = unknown.map{|id_ans, name_ans| "#{id_ans} = #{name_ans}"} +
  all.map{|id_rest, name_rest| "#{id_rest.join(' ')} = #{name_rest.join(' ')}"}

puts answer.sort
