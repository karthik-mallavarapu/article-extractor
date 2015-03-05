module Sanitizer
  
  INVALID_ELEM_TYPES = "//script|//style|//img|//figure"
  VALID_ELEM_TYPES = /(div|p|article|span)/
  
  def element_word_count(path)
    page.at(path).text.split(" ").length
  end

  def sanitize_elements(elem)
    elem.xpath(INVALID_ELEM_TYPES).remove
    elem
  end

  def link_density(elem)

  end

end
