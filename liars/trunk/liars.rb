members = Hash[*gets.split(?,).flat_map{|say| say.match(/(.):([A-Z]+)(\d+)/){|match| [match[1], [match[2].chars, match[3].to_i]]}}]

answers = [true, false].repeated_permutation(members.count).select do |pattern|
  judge = Hash[members.keys.zip(pattern)]
  judge.all?{|mem, pat| (members[mem][0].count{|m| judge[m]} == members[mem][1]) == pat}
end

puts (if answers.empty?
        'none'
      elsif answers.size > 1
        'many'
      elsif answers[0].uniq == [false]
        '-'
      else
        members.keys.zip(answers[0]).select(&:last).map(&:first).sort.join
      end)
