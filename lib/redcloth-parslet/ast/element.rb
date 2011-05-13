module RedClothParslet::Ast
  class Element
    attr_accessor :contained_elements
    attr_accessor :opts
    
    def initialize(contained_elements=[], opts=[])
      contained_elements = [contained_elements] unless contained_elements.is_a?(Array)
      @contained_elements = contained_elements
      @opts = apply_attributes(opts)
    end
    
    def apply_attributes(attribute_hashes)
      attribute_hashes = [attribute_hashes] unless attribute_hashes.is_a?(Array)
      style = {}
      opts = {}
      attribute_hashes.each do |attrs|
        attrs.each do |k,v|
          case k
          when :padding
            l_or_r = v == '(' ? 'left' : 'right'
            style["padding-#{l_or_r}"] ||= 0
            style["padding-#{l_or_r}"] += 1
          when :align
            style["text-align"] = if style["text-align"] == "left" && v == ">"
              "justify" 
            else
              {'<'=>'left','>'=>'right','='=>'center'}[v]
            end
          else
            opts[k.to_s] = ((opts[k.to_s] || '').split(/\s/) + [v]).join(' ')
          end
        end
      end
      opts['style'] = style.map do |k,v|
        case k
        when /padding/
          "#{k}:#{v}em"
        when 'text-align'
          "#{k}:#{v}"
        end
      end.join("; ") if style.any?
      opts
    end
    
    def ==(other)
      other.class == self.class &&
      contained_elements == other.contained_elements &&
      opts == other.opts
    end
  end
end