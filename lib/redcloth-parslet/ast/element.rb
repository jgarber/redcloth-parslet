module RedClothParslet::Ast
  class Element
    attr_accessor :children
    attr_accessor :opts
    
    # TODO: Make +children+ argument optional so things like Img can just pass opts as first argument.
    def initialize(children=[], opts={})
      @children = children.is_a?(Array) ? children : [children]
      @opts = opts
    end
    
    # TODO: Cache in a hash like Kramdown does? Or memoize in a class var? Or define
    # in each class so it doesn't have to get generated at all? Find out with benchmarking.
    def type
      self.class.to_s.gsub(/.*::/, '').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase.to_sym
    end
    
    def ==(other)
      other.class == self.class &&
      children == other.children &&
      opts == other.opts
    end
    
    # TODO: abstract this into RedClothParslet::Formatter::HTML
    # Convert the element to HTML
    # 
    def to_html(opts={})
      type = self.class.downcase
      contents = children.map {|el| el.to_html(opts) unless el.is_a?(String) }.join
      "<#{type}>contents</#{type}>"
    end
    
    
  end
end