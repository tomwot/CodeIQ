# ƒŠƒ“ƒS—ñŒvŽZ

$min = 99999999

def get_ringo(ringos, char_count, answers, score)
  if char_count.empty?
    $min = [$min, score].min
    return score
  end

  return nil if ringos.empty?

  char, count = char_count.shift

  ringos1 = ringos.dup

  answer1 = ringos1.shift
  current_score1 = score + answer1.length * count
  if $min <= current_score1
    score1 = nil
  else
    next_ringos1 = ringos1.dup.delete_if{|rr| rr =~ /^#{answer1}/}
    score1 = get_ringo(next_ringos1.dup, char_count.dup, answers, current_score1)
  end

#  puts "a1, #{char}, #{answer1}, #{score1}"

  answer2 = "#{answer1}r"
  current_score2 = score + answer2.length * count
  if $min <= current_score2
    score2 = nil
  else
    next_ringos2 = ringos1.dup.delete_if{|rr| rr =~ /^#{answer2}/}
    score2 = get_ringo(next_ringos2.dup, char_count.dup, answers, current_score2)
  end

#  puts "a2, #{char}, #{answer2}, #{score2}"

  if score1.nil? && score2.nil?
    return nil
  elsif score1.nil?
    answers[char] = answer2
    return score2.tap{|s| puts "a1, #{char}, #{answer1}, #{score1}, #{answer2}, #{score2}"}
  elsif score2.nil?
    answers[char] = answer1
    return score1.tap{|s| puts "a2, #{char}, #{answer1}, #{score1}, #{answer2}, #{score2}"}
  elsif score1 > score2
    answers[char] = answer2
    return score2.tap{|s| puts "a3, #{char}, #{answer1}, #{score1}, #{answer2}, #{score2}"}
  else
    answers[char] = answer1
    return score1.tap{|s| puts "a4, #{char}, #{answer1}, #{score1}, #{answer2}, #{score2}"}
  end
end

puts start = Time.now

typical = ARGF.read
char_count = ("A".."Z").map{|char| [char, typical.count(char)]}.sort_by{|cc| -cc[1]}
ringos = (1..5).to_a.map{|n| ['r', 'g', 'b'].repeated_permutation(n).to_a.map{|rr| rr.join}}.flatten

answers = Hash[*char_count.map{|c, n| [c, ""]}.flatten]

score = get_ringo(ringos, char_count, answers, 0)

puts finish = Time.now
puts
puts finish-start
puts
puts answers.map{|char, ringo| "#{char}:#{ringo}"}#.sort
puts
puts "score: #{score}"
