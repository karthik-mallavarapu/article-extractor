module Similarity
  
  def score_results(result_paths)
    result_paths.each_with_index do |path, index|
      result_nodes << ResultNode.new(path, page.at(path).text, index)
    end
    root = result_nodes.max_by { |node| node.tokens.length } 
    root.score = 1.0
    result_nodes.each do |node|
      unless node == root
        node.score = similarity_score(root.tokens, node.tokens)  
      end
    end
    sorted_results = result_nodes.select { |node| node.score >= 0.5 }.sort_by { |node| node.index }
    sorted_results.reduce('') { |content, r| content + r.text }
    #sanitized_elem = sanitize_elements(elem)
    #return sanitized_elem.text.gsub(/\s{2,}/, "\n") 
    
  end

  def similarity_score(root_tokens, elem_tokens)
    score = 0
    elem_tokens.each do |word, count|
      score += [root_tokens.fetch(word, 0), count].min
    end
    score /= (Math.log(token_count(root_tokens)) + Math.log(token_count(elem_tokens)))
  end

  private

  def token_count(tokens)
    total = 0
    tokens.each { |word, count| total += count } 
    total
  end

end
