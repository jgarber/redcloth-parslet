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
  end
end