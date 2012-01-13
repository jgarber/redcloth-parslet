module RedClothParslet::Ast
  class Base
    def initialize(str)
      @str = String(str)
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
    
    def to_s
      @str
    end
    
    def ==(other)
      self.to_s == other.to_s
    end
    
    # FIXME: are these necessary on any Ast classes? I don't think it's used anymore.
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