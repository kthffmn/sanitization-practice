require_relative "./sanitized.rb"
require 'pry'

def fetch_data
  game_file = File.open("./sanitized.rb", "r")
  eval(game_file.read)
end

def iterate
  notes = {}
  counter = 0
  game_data = fetch_data
  game_data.each_with_index do |g, i|
    if g[:notes]
      if g[:notes].length > 0
        counter += 1
        notes[g[:name]] = g[:notes]
      end
    end
  end
  return ["counter: #{counter}", notes]
end

puts iterate
puts iterate.length