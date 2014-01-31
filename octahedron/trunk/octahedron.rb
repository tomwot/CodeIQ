ARGF.each do |line|
  # {�]�������� => �]��������̓V�ʂ̐F}
  octahedron = {'2' => 'G', '4' => nil, '6' => 'R', '8' => nil, 'T' => 'B', 'D' => nil}
  print top = 'Y'

  line.chomp.chars do |c|
    # �]�����O�̓V�ʂ̐F�Ɠ]��������̓V�ʂ̐F�Ƃ̓���ւ��B
    octahedron[c], top = top, octahedron[c]

    # �����ŁAoctahedron��{�V�ʂ̕ӂ̕��� => ���̕ӂɐڂ���ʂ̐F}���w���B

    # �u�V�ʂ̕ӂ̕����v�̔��Ε����ɓ]�������Ƃ��ɁA
    # �u���̕ӂɐڂ���ʂ̐F�v���V�ʂ̐F�ɂȂ�l�ɐF�����ւ���B
    [['6', 'D'], ['2', '8'], ['4', 'T']].each do |a, b|
      octahedron[a], octahedron[b] = octahedron[b], octahedron[a]
    end

    print top
  end
  puts
end
