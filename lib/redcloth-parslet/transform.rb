class RedClothParslet::Transform < Parslet::Transform
  
  rule(:s => simple(:s)) { String(s) }
  rule(:content => subtree(:c), :attributes => subtree(:a)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a])} }
  rule(:content => subtree(:c), :attributes => subtree(:a), :href => simple(:h)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:href => dict[:h]}))} }
  
  rule(:em => subtree(:a)) { RedClothParslet::Ast::Em.new(a[:content], a[:opts]) }
  rule(:strong => subtree(:a)) { RedClothParslet::Ast::Strong.new(a[:content], a[:opts]) }
  rule(:link => subtree(:a)) { RedClothParslet::Ast::Link.new(a[:content], a[:opts]) }
  
end
