require_relative "./sanitized.rb"
require 'pry'

def fetch_data
  game_file = File.open("./sanitized.rb", "r")
  eval(game_file.read)
end

def iterate
  no_name = []
  no_description = []
  game_data = fetch_data
  game_data.each do |g|
    unless g[:name]
      no_name << game_data.index(g)
    end
    unless g[:description]
      no_description << game_data.index(g)
    end
  end
  return {:no_description => no_description, :no_name => no_name }
end
