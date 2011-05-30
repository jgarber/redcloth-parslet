module RedClothParslet::Ast
  class Attributes < Hash
    def initialize(attribute_hashes)
      attribute_hashes = [attribute_hashes] unless attribute_hashes.is_a?(Array)
      attribute_hashes.each do |attrs|
        attrs.each do |k,v|
          case k
          when :padding
            style = self[:style] ||= {}
            l_or_r = v == '(' ? 'left' : 'right'
            style["padding-#{l_or_r}"] ||= 0
            style["padding-#{l_or_r}"] += 1
          when :align
            style = self[:style] ||= {}
            style["text-align"] = if style["text-align"] == "left" && v == ">"
              "justify" 
            else
              {'<'=>'left','>'=>'right','='=>'center'}[v]
            end
          else
            self[k] = ((self[k] || '').split(/\s/) + [v]).join(' ')
          end
        end
      end
      self
    end
    
    
  end
end