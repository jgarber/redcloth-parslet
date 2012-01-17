module RedClothParslet::Ast
  class Element < Base
    attr_accessor :children
    attr_accessor :opts
    
    # TODO: Make +children+ argument optional so things like Img can just pass opts as first argument.
    def initialize(children=[], opts={})
      @children = children.is_a?(Array) ? children : [children]
      @opts = opts
    end

    def to_s
      children.reduce(:to_s)
    end

    def inspect
      "#{type}:(#{children.reduce(:inspect)})"
    end
    
    def ==(other)
      other.class == self.class &&
      children == other.children &&
      opts == other.opts
    end
  end
end