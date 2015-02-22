# https://codeiq.jp/ace/nabetani_takenori/q1318

# ü‘ÎÌ‚Æ‚È‚é‘ÎÌ²‚Ì–{”‚ğ‹‚ß‚éB

def solve(prms)
  edges = prms[:edges].split(',').map{|points| points.chars.map{|point| [*'A'..'Z'].index(point) * 2}.sort}
  (0...prms[:n]).count{|ax| edges.all?{|ed| edges.include?(ed.map{|e| (ax * 2 - e) % (prms[:n] * 2)}.sort)}}
end


def decode(value)
  case value
  when Rational
    if value.denominator == 1
      value.to_i
    else
      value.to_f
    end
  else
    value
  end
end


def encode(value)
  case value
  when /\A\d+(?:\.\d+)?\z/
    value.to_r
  else
    value
  end
end

prms_name = %i( id n edges expect )

$stdout.sync = true

answers = ARGF.each_with_object([]) do |line, memo|
  prms = Hash[prms_name.zip(line.chomp.split("\t").map{|v| encode(v)})]

  id = decode(prms.delete(:id))

  prms[:estimate] = solve(prms)
  if prms[:estimate] == prms[:expect]
    puts "#{id}: Correct."
  else
    puts "#{id}: Wrong."
    puts '  ' << prms.map{|name, value| "#{name}: #{decode(value)}"}.join(', ')
    memo << id
  end
end
puts
puts 'answer:'
puts answers.join(',')

