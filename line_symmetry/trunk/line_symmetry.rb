# https://codeiq.jp/ace/nabetani_takenori/q1318

# ���Ώ̂ƂȂ�Ώ̎��̖{�������߂�B

# ��ӂɉ����Ώ̎��́A
# �E�S�ĉ~�̒��S��ʂ�B
# �E�u�^����ꂽ�~����̓_�̂����ꂩ�v�܂��́u�אڂ���^����ꂽ�~�����2�_�̐����񓙕����Ɖ~�Ƃ̌�_�v��ʂ�B
#�i�ؖ����j

prms_name = %i( n edges expect )

def solve(prms)
  edges = prms[:edges].split(',').map{|points| points.chars.map{|point| [*'A'..'Z'].index(point) * 2}.sort}
  (0...prms[:n]).count{|ax| edges.all?{|ed| edges.include?(ed.map{|e| (ax * 2 - e) % (prms[:n] * 2)}.sort)}}
end


# Restricted Hash
class RHash < Hash
  def []=(key, value)
    case value
    when /\A\d+(?:\.\d+)?\z/
      super(key, value.to_r)
    else
      super
    end
  end

  def to_s
    map do |k, v|
      v1 = case v
      when Rational
        if v.denominator == 1
          v.numerator
        else
          v.to_f
        end
      else
        v
      end
      "#{k}: #{v1}"
    end.join(', ')
  end
end

$stdout.sync = true

answers = ARGF.each_with_object([]) do |line, memo|
  id, *prms_str = line.chomp.split("\t")
  prms = RHash.new
  prms_name.zip(prms_str){|name, value| prms[name] = value}

  prms[:estimate] = solve(prms)
  if prms[:estimate] == prms[:expect]
    puts "#{id}: Correct."
  else
    puts "#{id}: Wrong."
    puts "  #{prms}"
    memo << id
  end
end
puts
puts 'answer:'
puts answers.join(',')
