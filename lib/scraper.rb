module Scraper

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

  # Find all text elements within the range of 100 and 5000 characters 
  # Filter the elements to only include div, p and article. 
  def find_text_elements
    parent_elems= Set.new
    # Get all nodes with a character count > 100 and < 5000.
    text_nodes = page.search("//body//*/text()[string-length(normalize-space()) < 5000 and string-length(normalize-space()) > 100]/..").map { |node| node.path }
    # Discard nodes that are not of type div, p or article.
    filtered_xpaths = text_nodes.select { |path| path =~ ELEM_FILTER }
  end

  # Iterate over the parents_elems array to find pairs of siblings.
  # If siblings, add the common parent or else if parents are siblings, 
  # add their common grand parent.
  def group_sibling_elems(elems)
    result_paths = Set.new
    if elems.length == 1
      result_paths << elems[0]
      return
    end
    elems.each do |elem1|
      result_candidate = elem1 
      elems.each do |elem2|
        unless elem1 == elem2
          if sibling?(elem1, elem2)
            result_candidate = parent_path(elem1)
          elsif sibling?(parent_path(elem1), parent_path(elem2))
            result_candidate = parent_path(parent_path(elem1))
          end
        end
      end
      result_paths << result_candidate
    end
    temp_results = result_paths.to_a
    temp_results.each { |path| result_paths.delete(path) if temp_results.include? parent_path(path) }
    # FIXME: Parents and children should not be present in results_path set
    result_paths
  end

  private
  
  def parent_path(path)
    path.split("/")[0..-2].join("/")
  end

  def sibling?(path1, path2)
    parent_path(path1) == parent_path(path2)
  end
  
end
