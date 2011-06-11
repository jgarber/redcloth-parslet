module RedClothParslet::Formatter
  class HTML
    def initialize(options={})
      @options = options
    end
    
    def convert(root)
      @output = ""
      @stack = []
      send(root.type, root)
    end
    
    def textile_doc(el)
      inner(el).chomp
    end
    
    # Return the converted content of the children of +el+ as a string. The parameter +indent+ has
    # to be the amount of indentation used for the element +el+.
    #
    # Pushes +el+ onto the @stack before converting the child elements and pops it from the stack
    # afterwards.
    def inner(el)
      result = ''
      @stack.push(el)
      el.children.each do |inner_el|
        if inner_el.is_a?(String)
          result << inner_el
        elsif inner_el.respond_to?(:type)
          result << send(inner_el.type, inner_el)
        end
      end
      @stack.pop
      result
    end
    
    [:h1, :h2, :h3, :h4, :h5, :h6, :p, :pre, :div].each do |m|
      define_method(m) do |el|
       "<#{m}#{html_attributes(el.opts)}>#{inner(el)}</#{m}>\n"
      end
    end

    [:strong, :code, :em, :i, :b, :ins, :sup, :sub, :span, :cite].each do |m|
      define_method(m) do |el|
       "<#{m}#{html_attributes(el.opts)}>#{inner(el)}</#{m}>"
      end
    end
    
    private
    
    # Return the HTML representation of the attributes +attr+.
    def html_attributes(attr)
      attr[:style] = attr[:style].map do |k,v|
        case k
        when /padding/
          "#{k}:#{v}em"
        when 'text-align'
          "#{k}:#{v}"
        end
      end.join("; ") if attr[:style]
      attr.map {|k,v| v.nil? ? '' : " #{k}=\"#{escape_html(v.to_s, :attribute)}\"" }.join('')
    end
    
    # :stopdoc:
    ESCAPE_MAP = {
      '<' => '&lt;',
      '>' => '&gt;',
      '&' => '&amp;',
      '"' => '&quot;',
      "\n" => "<br />",
      "'" => "&#39;"
    }
    ESCAPE_ALL_RE = /<|>|&|\n|"|'/
    ESCAPE_PRE_RE = Regexp.union(/<|>|&/)
    ESCAPE_ATTRIBUTE_RE = Regexp.union(/<|>|&|"/)
    ESCAPE_RE_FROM_TYPE = {
      :all => ESCAPE_ALL_RE,
      :pre => ESCAPE_PRE_RE,
      :attribute => ESCAPE_ATTRIBUTE_RE
    }
    # :startdoc:

    # Escape the special HTML characters in the string +str+. The parameter +type+ specifies what
    # is escaped: :all - all special HTML characters as well as entities, :pre - all special HTML
    # characters except breaks and quotes and :attribute - all special HTML
    # characters including the quotation mark but with no curly single quote.
    def escape_html(str, type = :all)
      str.gsub(ESCAPE_RE_FROM_TYPE[type]) {|m| ESCAPE_MAP[m] || m}
    end
    
  end
end