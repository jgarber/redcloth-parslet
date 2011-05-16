class RedClothParslet::Transform < Parslet::Transform
  
  rule(:s => simple(:s)) { String(s) }
  rule(:content => subtree(:c), :attributes => subtree(:a)) {|dict| {:content => dict[:c], :opts => merge_attributes(dict[:a])} }
  rule(:content => subtree(:c), :attributes => subtree(:a), :href => simple(:h)) {|dict| {:content => dict[:c], :opts => merge_attributes(dict[:a].push({:href => dict[:h]}))} }
  
  rule(:em => subtree(:a)) { RedClothParslet::Ast::Em.new(a[:content], a[:opts]) }
  rule(:strong => subtree(:a)) { RedClothParslet::Ast::Strong.new(a[:content], a[:opts]) }
  rule(:link => subtree(:a)) { RedClothParslet::Ast::Link.new(a[:content], a[:opts]) }
  
  def merge_attributes(attribute_hashes)
    attribute_hashes = [attribute_hashes] unless attribute_hashes.is_a?(Array)
    opts = {}
    attribute_hashes.each do |attrs|
      attrs.each do |k,v|
        case k
        when :padding
          style = opts[:style] ||= {}
          l_or_r = v == '(' ? 'left' : 'right'
          style["padding-#{l_or_r}"] ||= 0
          style["padding-#{l_or_r}"] += 1
        when :align
          style = opts[:style] ||= {}
          style["text-align"] = if style["text-align"] == "left" && v == ">"
            "justify" 
          else
            {'<'=>'left','>'=>'right','='=>'center'}[v]
          end
        else
          opts[k] = ((opts[k] || '').split(/\s/) + [v]).join(' ')
        end
      end
    end
    opts
  end
  
end
