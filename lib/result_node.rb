class ResultNode
  attr_reader :text, :path, :index, :tokens
  attr_accessor :score

  def initialize(path, text, index)
    @path = path
    @text = text
    @index = index
    text_to_tokens
  end

  def text_to_tokens
    tokenizer = Punkt::SentenceTokenizer.new(text)
    words = tokenizer.tokenize_words(text).map { |token| token.to_s }
    @tokens = remove_stopwords(words)
  end

  private
  def remove_stopwords(words)
    stop_words = File.read(File.join(File.dirname(__FILE__), '..', 'stop_words.txt')).split("\n")
    words.reject { |word| stop_words.include? word }.reduce(Hash.new) { |h, w| h.update(w => h.fetch(w,0) + 1) }
  end

end
