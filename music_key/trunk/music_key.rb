sound_list = %w( C Cs D Ds E F Fs G Gs A As B )
major = sound_list.select{|s| s.length == 1}.map{|s| sound_list.index(s)}
sound_lists = sound_list.map.with_index{|s, i| sound_list.values_at(*major.map{|m|(m+i)%12})}
gets.to_i.times do
  n_sounds = gets.to_i
  sounds = gets.chomp.split.uniq
  ans = sound_lists.select{|sl| sounds & sl == sounds}
  if ans.empty?
    puts 'invalid'
  else
    puts ans.map{|sl| sl.first}.join(' ')
  end
end
