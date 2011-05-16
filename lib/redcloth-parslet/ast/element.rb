module RedClothParslet::Ast
  class Element
    attr_accessor :contained_elements
    attr_accessor :opts
    
    def initialize(contained_elements=[], opts={})
      contained_elements = [contained_elements] unless contained_elements.is_a?(Array)
      @contained_elements = contained_elements
      @opts = opts
    end
    
    def ==(other)
      other.class == self.class &&
      contained_elements == other.contained_elements &&
      opts == other.opts
    end
    
    # TODO: abstract this into RedClothParslet::Formatter::HTML
    # Convert the element to HTML
    # 
    def to_html(opts={})
      type = self.class.downcase
      contents = contained_elements.map {|el| el.to_html(opts) unless el.is_a?(String) }.join
      "<#{type}>contents</#{type}>"
    end
    
    
  end
end