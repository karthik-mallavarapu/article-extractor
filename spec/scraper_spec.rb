require 'spec_helper'

describe Scraper do
  describe '#get_title' do

  end

  describe '#find_text_elements' do
    
    subject(:article) {Article.new("file:///#{Dir.pwd}/spec/test_html.html")}
    
    it "returns elements with text > 100 and < 5000 characters in length" do
      expect(article.find_text_elements).to include "/html/body/div/div[2]"            
    end

    it "does not include elements with less text" do
      expect(article.find_text_elements).not_to include "/html/body/div/div[1]"
    end
    
    it "does not include elements with more than 5000 characters text" do
      expect(article.find_text_elements).not_to include "/html/body/div/div[3]"
    end

    ["div", "p", "article"].each do |elem|
      it "includes elements of type #{elem} from elements on page" do 

      end
    end
  end

  describe '#compute_result_nodes' do 
  
    subject(:article) {Article.new("file:///#{Dir.pwd}/spec/test_html.html")}

    before {
      paths = [
        "div/div[0]/div[2]/div/p",
        "div/div[0]/div[2]/div[1]/p",
        "div/div[0]/div[2]/div[2]/p",
        "div/div[0]/div[2]/div/article",
        "div/div[1]/div[2]/div/p"
      ]
      article.compute_result_nodes(paths)
    }

    context "when merging siblings" do
      it "adds parent element to result set for a pair of siblings." do
        expect(article.result_nodes).to include("div/div[0]/div[2]/div")
      end
      
      it "adds parent of parent element to result set for a pair of parent siblings" do
        expect(article.result_nodes).to include("div/div[0]/div[2]")
      end

      it "does not include a child element if part of a sibling" do
        expect(article.result_nodes).not_to include("div/div[0]/div[2]/div/article")
      end

      it "checks the parent path hierarchically" do
        expect(article.result_nodes).to include("div/div[1]/div[2]/div/p")
      end

    end
  end
end
