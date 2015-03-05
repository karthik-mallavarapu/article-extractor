require 'nokogiri'
require 'mechanize'
require 'punkt-segmenter'
require "article/version"
require "scraper"
require "sanitizer"
require "similarity"
require 'result_node'
require 'set'
require 'pry'

class Article
  
  include Scraper 
  include Sanitizer
  include Similarity
  
  attr_reader :page, :result_nodes

  def initialize(url)
    begin
      agent = Mechanize.new
      @page = agent.get url
      @result_nodes = [] 
    rescue Exception => e
      puts e.backtrace.join("\n")
    end
  end
  
  def get_content
    elems = find_text_elements
    grouped_elems = group_sibling_elems(elems) 
    score_results(grouped_elems) 
  end

end
