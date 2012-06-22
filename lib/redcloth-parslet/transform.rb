class RedClothParslet::Transform < Parslet::Transform

  rule(:s => simple(:s)) { String(s) }
  rule(:s => simple(:s), :footnote_reference => simple(:footnote_reference)) { [String(s), RedClothParslet::Ast::FootnoteReference.new(String(footnote_reference))] }
  rule(:caps => simple(:s)) { RedClothParslet::Ast::Caps.new(String(s)) }
  rule(:content => subtree(:c)) {|dict| {:content => dict[:c], :opts => {}} }
  rule(:content => subtree(:c), :attributes => subtree(:a)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a])} }
  rule(:content => subtree(:c), :attributes => subtree(:a), :href => simple(:h)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:href => dict[:h]}))} }
  rule(:attributes => subtree(:a), :src => simple(:s)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s]}))} }
  rule(:attributes => subtree(:a), :src => simple(:s), :alt => simple(:alt)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s], :alt => dict[:alt]}))} }
  rule(:attributes => subtree(:a), :src => subtree(:s), :href => simple(:h)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s], :alt => dict[:alt], :href => dict[:h]}))} }

  rule(:layout => simple(:l), :continuation => simple(:cont), :attributes => subtree(:a), :content => subtree(:c)) {|dict|
    {:layout => dict[:l], :continuation => dict[:cont], :content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a])}
  }

  rule(:extended => subtree(:ext)) { ext[:successive].unshift(ext[:first]) }
  RedClothParslet::Parser::Block::SIMPLE_BLOCK_ELEMENTS.each do |block_type|
    rule(block_type => subtree(:a)) do
      RedClothParslet::Ast::const_get(block_type.to_s.capitalize).new(a[:content], a[:opts])
    end
  end
  rule(:p_open_quote => subtree(:a)) { RedClothParslet::Ast::P.new(a[:content], a[:opts].merge(:possible_unfinished_quote_paragraph => true)) }
  rule(:notextile => simple(:c)) { RedClothParslet::Ast::Notextile.new(c) }
  rule(:html_tag => simple(:c)) { RedClothParslet::Ast::HtmlTag.new(c) }
  rule(:pre => simple(:c)) { RedClothParslet::Ast::Pre.new(c) }
  rule(:pre_tag => subtree(:a)) do
    RedClothParslet::Ast::Pre.new(a[:content], {:open_tag => String(a[:open_tag])})
  end
  rule(:code_tag => subtree(:a)) do
    RedClothParslet::Ast::Code.new(a[:content], {:open_tag => String(a[:open_tag])})
  end
  rule(:bq => subtree(:a)) { RedClothParslet::Ast::Blockquote.new(a[:content], a[:opts]) }
  rule(:bc => simple(:c)) { RedClothParslet::Ast::Blockcode.new(c) }
  rule(:list => subtree(:a)) { RedClothParslet::Ast::List.build(a[:content], a[:opts]) }
  rule(:footnote => subtree(:a)) { RedClothParslet::Ast::Footnote.new(a[:content], a[:opts]) }
  rule(:link_alias => subtree(:a)) { link_aliases[String(a[:alias])] = String(a[:href]); nil }
  rule(:table => subtree(:a)) { RedClothParslet::Ast::Table.new(a[:content], a[:opts]) }
  rule(:table_row => subtree(:a)) { RedClothParslet::Ast::TableRow.new(a[:content], a[:opts]) }
  rule(:table_data => subtree(:a) ) do #, :leading_space => simple(:ls), :trailing_space => simple(:ts)) do
    RedClothParslet::Ast::TableData.new(a[:content], a[:opts])
  end
  rule(:table_header => subtree(:a)) { RedClothParslet::Ast::TableHeader.new(a[:content], a[:opts]) }
  rule(:hr => subtree(:a)) { RedClothParslet::Ast::Hr.new() }

  RedClothParslet::Parser::Inline::SIMPLE_INLINE_ELEMENTS.each do |block_type, symbol|
    rule(block_type => subtree(:a)) do
      RedClothParslet::Ast::const_get(block_type.to_s.capitalize).new(a[:content], a[:opts])
    end
  end
  rule(:double_quoted_phrase_or_link => subtree(:a)) do
    if a[:opts].has_key?(:href)
      RedClothParslet::Ast::Link.new(a[:content], a[:opts])
    else
      RedClothParslet::Ast::DoubleQuotedPhrase.new(a[:content])
    end
  end
  rule(:forced_quote => subtree(:q)) { ['[', q, ']'] }
  rule(:parentheses => subtree(:a)) { ['(', a[:content], ')'] }
  rule(:image => subtree(:a)) do
    if href = a[:opts].delete(:href)
      RedClothParslet::Ast::Link.new(RedClothParslet::Ast::Img.new([], a[:opts]), {:href => href})
    else
      RedClothParslet::Ast::Img.new([], a[:opts])
    end
  end
  rule(:acronym => subtree(:a)) { RedClothParslet::Ast::Acronym.new(RedClothParslet::Ast::Caps.new(a[:content]), a[:opts]) }

  rule(:dimension => simple(:d)) { RedClothParslet::Ast::Dimension.new(d) }
  rule(:entity => simple(:e)) { RedClothParslet::Ast::Entity.new(e) }
  rule(:entity => simple(:e), :left => subtree(:l), :left_space => simple(:l_sp), :right => subtree(:r), :right_space => simple(:r_sp)) do
    [l, String(l_sp), RedClothParslet::Ast::Entity.new(e), String(r_sp), r]
  end
end
