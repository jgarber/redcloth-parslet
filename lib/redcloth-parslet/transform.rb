class RedClothParslet::Transform < Parslet::Transform
  
  # For now we're stuck with spelling out the whole module heirarchy for accessing AST classes. It should work with just Ast::Em if these were simple method definitions (see http://stackoverflow.com/questions/4855926). Lack of consistency in the execution environment for parslet's transformation blocks is intentional according to its author.
  
  rule(:s => simple(:s)) { String(s) }
  rule(:inline => '_', :content => sequence(:c), :attributes => subtree(:a)) { RedClothParslet::Ast::Em.new(c, a) }
  rule(:inline => '*', :content => sequence(:c), :attributes => subtree(:a)) { RedClothParslet::Ast::Strong.new(c, a) }
  rule(:href => simple(:h), :content => sequence(:c), :attributes => subtree(:a)) { RedClothParslet::Ast::Link.new(c, a.push(:href=>h)) }
  
  # attr_accessor :doc
  # 
  # def initialize(doc)
  #   @doc = doc
  #   super()
  # end
  # 
  # rule(:s => simple(:s)) do |match|
  #   Nokogiri::XML::Text.new(match[:s], doc)
  # end
  # 
  # rule(:inline => simple(:i), :content => sequence(:c), :attributes => subtree(:a)) do |match|
  #   name = {'*'=>'strong', '_'=>'em'}[match[:i]]
  #   Nokogiri::XML::Element.new(name, doc) do |n|
  #     apply_attributes(n, match[:a])
  #     n.add_child(Nokogiri::XML::NodeSet.new(doc, match[:c]))
  #   end
  # end
  # 
  # def apply_attributes(node, attribute_hashes)
  #   style = {}
  #   attribute_hashes.each do |attrs|
  #     attrs.each do |k,v|
  #       case k
  #       when :padding
  #         l_or_r = v == '(' ? 'left' : 'right'
  #         style["padding-#{l_or_r}"] ||= 0
  #         style["padding-#{l_or_r}"] += 1
  #       when :align
  #         style["text-align"] = if style["text-align"] == "left" && v == ">"
  #           "justify" 
  #         else
  #           {'<'=>'left','>'=>'right','='=>'center'}[v]
  #         end
  #       else
  #         node[k.to_s] = ((node[k.to_s] || '').split(/\s/) + [v]).join(' ')
  #       end
  #     end
  #   end
  #   node['style'] = style.map do |k,v|
  #     case k
  #     when /padding/
  #       "#{k}:#{v}em"
  #     when 'text-align'
  #       "#{k}:#{v}"
  #     end
  #   end.join("; ") if style.any?
  #   
  # end
end
