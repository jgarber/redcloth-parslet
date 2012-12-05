module RedClothParslet::Ast
  class Element < Base
    attr_accessor :children
    #FIXME: rename opts -> attrs
    attr_accessor :opts
    
    # TODO: Make +children+ argument optional so things like Img can just pass opts as first argument.
    def initialize(*args)
      @opts = initialize_attributes(args)
      @children = args.flatten
    end
    
    def initialize_attributes(args)
      if args.last.is_a?(Hash)
        args.pop
      else
        {}
      end
    end

    def to_s
      children.reduce(:to_s)
    end

    def inspect
      opts_inspection = " opts:#{opts.inspect}"
      children_inspection = " children:#{children.inspect}"
      "#<#{self.class}#{opts_inspection if opts && opts.any?}#{children_inspection if children.any?}>"
    end
    
    def ==(other)
      other.class == self.class &&
      children == other.children &&
      opts == other.opts
    end
  end
end