require 'nokogiri'
require 'open-uri'
require 'uri'
require 'debugger'

class Scraper
  attr_accessor :links, :content, :num_of_links
  attr_reader :index

  def initialize
    @index = Nokogiri::HTML(open('http://improvencyclopedia.org/games/index.html'))
    @links = []
    @content = {}
    @num_of_links
  end

  def main
    links = get_links
    num_of_links = links.length
    counter = 1
    until links.length < 1
      scrape_page(URI::encode(links.shift), counter, num_of_links)
      counter += 1
    end
    content
  end

  def get_links
    index.search("ul li").collect{|e| e.children.first['href']} 
  end

  def scrape_page(game_link, counter, total)
    puts "#{counter}/#{total}: #{game_link}"
    doc = Nokogiri::HTML(open(game_link))
    content[doc.search("h2").text()] = doc.search('#midPanel').text()
  end

end