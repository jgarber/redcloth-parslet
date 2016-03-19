module RedClothParslet::Ast
  class Attributes < Hash
    def initialize(attribute_hashes)
      attribute_hashes = [attribute_hashes] unless attribute_hashes.is_a?(Array)
      attribute_hashes.each do |attrs|
        attrs.each do |k,v|
          case k
          when :padding
            l_or_r = v == '(' ? 'left' : 'right'
            style["padding-#{l_or_r}"] ||= 0
            style["padding-#{l_or_r}"] += 1
          when :align
            style["align"] = if style["align"] == "left" && v == ">"
              "justify" 
            else
              {'<'=>'left','>'=>'right','='=>'center'}[String(v)]
            end
          when :vertical_align
            style["vertical-align"] = {'^'=>'top', '-'=>'middle', '~'=>'bottom'}[String(v)]
          when :class
            self[k] = ((self[k] || '').split(/\s/) + [String(v)]).join(' ')
          when :style
            String(v).split(';').each do |declaration|
              property_name, value = declaration.split(':')
              style[property_name.strip] = value.rstrip
            end
          else
            self[k] = String(v)
          end
        end
      end
      self
    end
    
    def style
      self[:style] ||= {}
      self[:style]
    end
  end
  
  
end