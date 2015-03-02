require 'nokogiri'
require 'mechanize'
require "article/version"
require "parser"
require "sanitizer"
require 'pry'

class Article
  
  include Parser
  include Sanitizer
  
  attr_reader :page, :result_nodes, :siblings

  def initialize(url)
    begin
      agent = Mechanize.new
      @page = agent.get url
      @result_nodes = []
      # Sibling info for each elem. Stores a boolean for every other parent
      # based on whether the pair are siblings/grand siblings.
      @siblings = Hash.new(false)
    rescue Exception => e
      puts e.backtrace.join("\n")
    end
  end
end
