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
      game = { :see_also => [] }
      info = split_data(data["content"])
      i = 0
      while i < info.length
        key = info[i].downcase.gsub(" ", "_").to_sym
        value = normalize_whitespace(info[i + 1]).strip
        if key == :see_also
          game[key] << value
        else
          game[key] = value
        end
        i += 2
      end
      all_games << game
    end
    all_games
  end

  def normalize_whitespace(data)
    data.gsub(/[[:space:]]+/, ' ')
  end

  def split_data(data)
    info = data.split(/(Description|Variations|See also)/i)
    info.unshift('Name')
  end

end