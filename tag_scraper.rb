require 'nokogiri'
require 'open-uri'
require 'uri'
require 'pry'

class Scraper
  attr_accessor :links, :content, :num_of_links
  attr_reader :index

  def initialize(url)
    @index = Nokogiri::HTML(open(url))
    @links = []
    @content = {}
    @num_of_links
  end

  def main
    tag_hash = {}
    links = get_links
    num_of_links = links.length
    counter = 1
    until links.length < 1
      tag, names = scrape_page(URI::encode(links.shift), counter, num_of_links)
      tag_hash[tag] = names
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
    names = []
    doc.search("p a").each do |link|
      names << link.text
    end
    tag = doc.search("div h2").text.strip
    [tag, names]
  end

end


my_scraper = Scraper.new("http://improvencyclopedia.org/categories/index.html")
puts my_scraper.main