module Parser

  ELEM_FILTER = /(div|div\[\d+\]|p|p\[\d+\]|article)\z/
  
  # Find all header elements. Precendence h1 > h2 > h3 applies. If multiple h1 nodes are found, find similarity with article text.
  def get_title
    headers = []
    ["h1", "h2", "h3", "h4"].each do |header|
      headers = page.search("//body//*/#{header}")
      break unless headers.empty?
    end
    headers.max_by { |h| h.text.length }.text
  end

  def get_content
    parents_elems= []
    # Get all nodes with a character count > 100 and < 5000.
    text_nodes = page.search("//body//*/text()[string-length(normalize-space()) < 5000 and string-length(normalize-space()) > 100]/..").map { |node| node.path }

    # Discard nodes that are not of type div, p or article.
    filtered_paths = text_nodes.select { |path| path =~ ELEM_FILTER }

    # Get the parent elements of matching text nodes and store them in an array.
    filtered_paths.each do |path|
      parents_elems << parent_path(path) unless parents_elems.include?(parent_path(path))
    end

    # Iterate over the parents_elems array to find pairs of siblings.
    # If 2 nodes are siblings, add their common parent to the result array.
    # If parents of 2 nodes are siblings, add the grand parent of the nodes
    # to the result_nodes array. 
    add_to_results(parents_elems[0]) if parents_elems.length == 1
    parents_elems.each do |elem|
      result_candidate = elem 
      parents_elems.each do |other|
        unless elem == other
          if sibling?(elem, other)
            result_candidate = parent_path(elem)
          elsif sibling?(parent_path(elem), parent_path(other))
            result_candidate = parent_path(parent_path(elem))
          end
        end
      end
      add_to_results(result_candidate)
    end
    score_results
  end

  private
  
  def parent_path(path)
    path.split("/")[0..-2].join("/")
  end

  def sibling?(path1, path2)
    parent_path(path1) == parent_path(path2)
  end
  
  def add_to_results(path)
    result_nodes << path unless result_nodes.include? path
  end

end
