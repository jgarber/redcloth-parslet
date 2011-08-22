class RedClothParslet::Transform < Parslet::Transform
  
  rule(:s => simple(:s)) { String(s) }
  rule(:content => subtree(:c)) {|dict| {:content => dict[:c], :opts => {}} }
  rule(:content => subtree(:c), :attributes => subtree(:a)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a])} }
  rule(:content => subtree(:c), :attributes => subtree(:a), :href => simple(:h)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:href => dict[:h]}))} }
  rule(:attributes => subtree(:a), :src => simple(:s)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s]}))} }
  rule(:attributes => subtree(:a), :src => simple(:s), :alt => simple(:alt)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s], :alt => dict[:alt]}))} }
  rule(:attributes => subtree(:a), :src => subtree(:s), :href => simple(:h)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s], :alt => dict[:alt], :href => dict[:h]}))} }
  
  rule(:layout => simple(:l), :attributes => subtree(:a), :content => subtree(:c)) {|dict|
    {:layout => dict[:l], :content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a])}
  }
  
  rule(:p => subtree(:a)) { RedClothParslet::Ast::P.new(a[:content], a[:opts]) }
  rule(:div => subtree(:a)) { RedClothParslet::Ast::Div.new(a[:content], a[:opts]) }
  rule(:heading => subtree(:a), :level=>simple(:l)) { RedClothParslet::Ast.const_get("H#{l}").new(a[:content], a[:opts]) }
  rule(:notextile => simple(:c)) { RedClothParslet::Ast::Notextile.new(c) }
  rule(:list => subtree(:a)) { RedClothParslet::Ast::List.build(a[:content], a[:opts]) }
  rule(:table => subtree(:a)) { RedClothParslet::Ast::Table.new(a[:content], a[:opts]) }
  rule(:table_row => subtree(:a)) { RedClothParslet::Ast::TableRow.new(a[:content], a[:opts]) }
  rule(:table_data => subtree(:a)) { RedClothParslet::Ast::TableData.new(a[:content], a[:opts]) }
  
  rule(:em => subtree(:a)) { RedClothParslet::Ast::Em.new(a[:content], a[:opts]) }
  rule(:strong => subtree(:a)) { RedClothParslet::Ast::Strong.new(a[:content], a[:opts]) }
  rule(:b => subtree(:a)) { RedClothParslet::Ast::B.new(a[:content], a[:opts]) }
  rule(:i => subtree(:a)) { RedClothParslet::Ast::I.new(a[:content], a[:opts]) }
  rule(:double_quoted_phrase_or_link => subtree(:a)) do
    if a[:opts].has_key?(:href)
      RedClothParslet::Ast::Link.new(a[:content], a[:opts])
    else
      RedClothParslet::Ast::DoubleQuotedPhrase.new(a[:content])
    end
  end
  rule(:image => subtree(:a)) do
    if href = a[:opts].delete(:href)
      RedClothParslet::Ast::Link.new(RedClothParslet::Ast::Img.new([], a[:opts]), {:href => href})
    else
      RedClothParslet::Ast::Img.new([], a[:opts])
    end
  end
  rule(:acronym => subtree(:a)) { RedClothParslet::Ast::Acronym.new(a[:content], a[:opts]) }
  
  rule(:entity => simple(:e)) { RedClothParslet::Ast::Entity.new(e) }
end
