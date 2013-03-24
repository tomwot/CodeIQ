module Triany
  # TLLI (Triany Low Level Interface)
  class TLLI
    def initialize
      @trianies = Hash.new{|hash, key| hash[key] = [nil, nil, nil]}
      @new_triany_id = 1

      @trianies[@new_triany_id] = [0, 0, 0]
    end

    def root_triany
      1
    end

    def allocate_triany
      @new_triany_id += 1
      @trianies[@new_triany_id] = [0, 0, 0]
      @new_triany_id
    end

    def set_a(id, value)
      set_value(id, FieldA, value)
    end

    def set_b(id, value)
      set_value(id, FieldB, value)
    end

    def set_c(id, value)
      set_value(id, FieldC, value)
    end

    def get_a(id)
      get_value(id, FieldA)
    end

    def get_b(id)
      get_value(id, FieldB)
    end

    def get_c(id)
      get_value(id, FieldC)
    end


    private
    FieldA, FieldB, FieldC = 0, 1, 2

    def set_value(id, field, value)
      if (1..@new_triany_id).include?(id)
        new_trianies = @trianies[id]
        new_trianies[field] = value
        @trianies[id].replace(new_trianies)
      end
    end

    def get_value(id, field)
      @trianies[id][field]
    end

  end

  # DICTI(Dictionary Interface)
  class DICTI
    def initialize
      @tlli = TLLI.new
    end

    def set_entry(key, value)
      return if key == 0 || value == 0
      id = @tlli.root_triany
      last_id = id
      while id > 0
        id_next, id_key, id_value = @tlli.get_a(id), @tlli.get_b(id), @tlli.get_c(id)
        break if key == id_key
        last_id = id
        id = id_next
      end
      if id == 0
        new_id = @tlli.allocate_triany
        @tlli.set_a(last_id, new_id)
        @tlli.set_b(new_id, key)
        @tlli.set_c(new_id, value)
      else
        @tlli.set_c(id, value)
      end
      nil
    end

    def find_entry(key)
      id = @tlli.root_triany
      last_id = id
      while id > 0
        id_next, id_key, id_value = @tlli.get_a(id), @tlli.get_b(id), @tlli.get_c(id)
        break if key == id_key
        last_id = id
        id = id_next
      end
      if id == 0
        0
      else
        @tlli.get_c(id)
      end
    end

  end
end

dicti = Triany::DICTI.new

ret = ARGF.map{|line|
  _, command, key, value = *line.chomp.match(/^(.) ?(\d+)? ?(\d+)?/)
  case command
  when '#'
    nil
  when 's'
    dicti.set_entry(key.to_i, value.to_i)
  when 'f'
    dicti.find_entry(key.to_i)
  else
    p command
    raise NotImplementedError, "command #{command}"
  end
}.compact.inject(:+)

#File.open('dicti.txt', 'w'){|file| file.puts dicti.inspect}
puts ret
