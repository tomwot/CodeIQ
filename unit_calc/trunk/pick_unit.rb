#coding: UTF-8
File.open('problem/data.utf8.txt', 'r:UTF-8') do |file|
  puts file.flat_map{|line| line.chomp.split("\t")[1, 2].flat_map{|equ| equ.split(/[-+=]/)}.flat_map{|item| item.scan(/(?:\d+|□)(\D+)/)}}.uniq
end
