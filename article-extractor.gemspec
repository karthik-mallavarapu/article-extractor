# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'article/version'

Gem::Specification.new do |spec|
  spec.name          = "article-extractor"
  spec.version       = Article::VERSION
  spec.authors       = ["Karthik Mallavarapu"]
  spec.email         = ["karthik.mallavarapu@gmail.com"]
  spec.summary       = %q{Extracts relevant text and title from a news webpage url}
  spec.description   = %q{Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  #spec.files         = `git ls-files -z`.split("\x0")
  spec.files = [
  "lib/article.rb",
  "lib/scraper.rb", 
  "lib/sanitizer.rb",
  "lib/similarity.rb",
  "lib/result_node.rb",
  "lib/article/version.rb",
  "stop_words.txt" 
  ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 10.4'
  spec.add_development_dependency "guard", '~> 2.1'
  spec.add_development_dependency "webmock", '~> 1.20'
  spec.add_development_dependency "rspec", '~> 3.2'
  spec.add_development_dependency "rspec-expectations", '~> 3.2'
  spec.add_development_dependency "rspec-mocks", '~> 3.2'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_dependency 'nokogiri', '~> 1.6'
  spec.add_dependency 'punkt-segmenter', '~> 0.9'
  spec.add_dependency 'mechanize', '~> 2.7'
end
