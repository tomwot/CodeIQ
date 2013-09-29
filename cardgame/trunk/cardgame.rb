ans = Hash.new(0)

card_order = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

ARGF.each do |line|
  hand = line.chomp.split(/,/).map{|card| card.scan(/([SDHC])(.+)/).flatten}

  suit_group = hand.group_by{|card| card[0]}
  num_group  = hand.group_by{|card| card[1]}

  prefix = main = ''

  case num_group.map{|num, cards| cards.size}.sort
  when [2, 4]
    main = 'An'
  when [3, 3]
    main = 'DT'
    prefix ='s' if suit_group.size == 3
  when [2, 2, 2]
    main = 'TP'
    prefix = 's' if suit_group.size == 2

    num_order = num_group.keys.map{|num| card_order.index(num)}.sort # 全て値が異なる事と要素数3であることが保証されている。
    prefix += 'c' if num_order.min + 2 == num_order.max || num_order == [0, 11, 12]
  else
    main = '-'
  end

  yaku = prefix + main
  ans[yaku] += 1

  puts "#{line.chomp} :#{yaku}"
end

puts
puts ['An', 'sDT', 'DT', 'scTP', 'cTP', 'sTP', 'TP'].map{|y| "#{y}:#{ans[y]}"}.join(',')
