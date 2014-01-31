ARGF.each do |line|
  # {転がす方向 => 転がした後の天面の色}
  octahedron = {'2' => 'G', '4' => nil, '6' => 'R', '8' => nil, 'T' => 'B', 'D' => nil}
  print top = 'Y'

  line.chomp.chars do |c|
    # 転がす前の天面の色と転がした後の天面の色との入れ替え。
    octahedron[c], top = top, octahedron[c]

    # ここで、octahedronは{天面の辺の方向 => その辺に接する面の色}を指す。

    # 「天面の辺の方向」の反対方向に転がしたときに、
    # 「その辺に接する面の色」が天面の色になる様に色を入れ替える。
    [['6', 'D'], ['2', '8'], ['4', 'T']].each do |a, b|
      octahedron[a], octahedron[b] = octahedron[b], octahedron[a]
    end

    print top
  end
  puts
end
