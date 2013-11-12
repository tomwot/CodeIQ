sound_list = %w( C Cs D Ds E F Fs G Gs A As B )
sound_lists = sound_list.map.with_index{|s, i| sound_list.values_at(*[0, 2, 4, 5, 7, 9, 11].map{|d|(d+i)%12})}
gets.to_i.times do
  n_sounds = gets.to_i
  sounds = gets.chomp.split.uniq.sort
  ans = sound_lists.select{|sl| sl.sort & sounds == sounds}
  if ans.empty?
    puts 'invalid'
  else
    puts ans.map{|sl| sl.first}.join(' ')
  end
end
