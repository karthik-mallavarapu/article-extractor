module Sanitizer
  
  INVALID_ELEM_TYPES = "//script|//style|//img|//figure"
  VALID_ELEM_TYPES = /(div|p|article|span)/
  
  def score_results
    if max_path = result_nodes.max_by { |path| element_word_count(path) }
      elem = page.at(max_path)
      content_elems = filter_elements(elem)
      content = content_elems.reduce('') { |content, elem| content + elem.text.gsub(/\s{2,}/, "\n") }
      return content
    end
  end
  
  def element_word_count(path)
    page.at(path).text.split(" ").length
  end

  def filter_elements(elem)
    elem.xpath(INVALID_ELEM_TYPES).remove
    valid_elems = elem.elements.select { |e| e.name =~ VALID_ELEM_TYPES }
  end

end
