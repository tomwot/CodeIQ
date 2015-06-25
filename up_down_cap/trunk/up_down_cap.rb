ARGF.each do |line|
  puts ({
    0             => line,
    line.ord % 3  => line.downcase,
    line.ord % 5  => line.upcase,
    line.ord % 15 => line.capitalize,
  })[0]
end
