require 'json'
require 'pry'

class Santitizer
  attr_reader :information
  def initialize(filename)
    @information = JSON.parse(IO.read(filename))
  end

  def main
    all_games = []
    information.each do |num, data|
      game = { :see_also => [], :variations => [], :also_known_as => [] }
      info = split_data(data["content"])
      i = 0
      while i < info.length
        key = info[i].downcase.gsub(" ", "_").to_sym
        value = normalize_whitespace(info[i + 1]).strip
        if key == :see_also || key == :variations || key == :also_known_as
          game[key] << value
        else
          game[key] = value
        end
        i += 2
      end
      all_games << game
    end
    write_file("sanitized.rb", all_games)
    return all_games
  end

  def write_file(file_name, data)
    out_file = File.new(file_name, "w")
    out_file.print(data)
    out_file.close
  end

  def normalize_whitespace(data)
    data.gsub(/[[:space:]]+/, ' ')
  end

  def split_data(data)
    info = data.split(/(Description|Variations|See also|Also known as)/i)
    info.unshift('Name')
  end

end

my_sanitizer = Santitizer.new("./unsanitized.json")
puts my_sanitizer.main.inspect
