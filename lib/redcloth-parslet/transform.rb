class RedClothParslet::Transform < Parslet::Transform

  rule(:s => simple(:s)) { String(s) }
  rule(:s => simple(:s), :footnote_reference => simple(:footnote_reference)) { [String(s), RedClothParslet::Ast::FootnoteReference.new(String(footnote_reference))] }
  rule(:caps => simple(:s)) { RedClothParslet::Ast::Caps.new(String(s)) }
  rule(:attributes => subtree(:a)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a])} }
  rule(:attributes => subtree(:a), :s => simple(:s)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a]), :content => String(dict[:s])} }

  # content
  rule(:content => subtree(:c)) {|dict| {:content => dict[:c], :opts => {}} }
  rule(:content => subtree(:c), :attributes => subtree(:a)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a])} }

  # links
  # rule(:content => subtree(:c), :href => simple(:h)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new({:href => dict[:h]})} }
  rule(:content => subtree(:c), :attributes => subtree(:a), :href => simple(:h)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:href => dict[:h]}))} }
  # rule(:content => subtree(:c), :bq_cite => simple(:h)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new({:cite => dict[:h]})} }
  rule(:content => subtree(:c), :attributes => subtree(:a), :bq_cite => simple(:h)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:cite => dict[:h]}))} }
  rule(:content => subtree(:c), :attributes => subtree(:a), :href => simple(:h), :title => simple(:t)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:href => dict[:h], :title => String(dict[:t])}))} }

  # images
  # Making the @alt@ property obligatory
  rule(:attributes => subtree(:a), :src => simple(:s)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s], :alt => dict[:alt]}))} }
  rule(:attributes => subtree(:a), :src => simple(:s), :alt => simple(:alt)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s], :alt => dict[:alt]}))} }
  rule(:attributes => subtree(:a), :src => subtree(:s), :href => simple(:h)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s], :alt => dict[:alt], :href => dict[:h]}))} }
  rule(:attributes => subtree(:a), :src => subtree(:s), :alt => simple(:alt), :href => simple(:h)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:src => dict[:s], :alt => dict[:alt], :href => dict[:h]}))} }

  # lists
  rule(:layout => simple(:l), :continuation => simple(:cont), :attributes => subtree(:a), :content => subtree(:c)) {|dict|
    {:layout => dict[:l], :continuation => dict[:cont], :content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a])}
  }
  rule(:layout => simple(:l), :attributes => subtree(:a), :content => subtree(:c)) {|dict|
    {:layout => dict[:l], :content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a])}
  }
  rule(:dl => subtree(:c)) { RedClothParslet::Ast::Dl.new(c) }
  rule(:dt => subtree(:dt), :dd => subtree(:dd)) do
    [ RedClothParslet::Ast::Dt.new(dt[:content]),
      RedClothParslet::Ast::Dd.new(dd[:content]) ]
  end
  rule(:dt => subtree(:dt)) { RedClothParslet::Ast::Dt.new(dt[:content]) }
  rule(:dd => subtree(:dd)) { RedClothParslet::Ast::Dd.new(dd[:content]) }

  rule(:extended => subtree(:ext)) { RedClothParslet::Ast::ExtendedBlock.new(ext[:content], ext[:opts]) }
  RedClothParslet::Parser::Block::SIMPLE_BLOCK_ELEMENTS.each do |block_type|
    rule(block_type => subtree(:a)) do
      RedClothParslet::Ast::const_get(block_type.to_s.capitalize).new(a[:content], a[:opts])
    end
  end
  rule(:p_open_quote => subtree(:a)) { RedClothParslet::Ast::P.new(a[:content], a[:opts].merge(:possible_unfinished_quote_paragraph => true)) }
  rule(:notextile => simple(:c)) { RedClothParslet::Ast::Notextile.new(c) }
  rule(:html_tag => simple(:c)) { RedClothParslet::Ast::HtmlTag.new(c) }
  rule(:pre => simple(:c)) { RedClothParslet::Ast::Pre.new(c) }
  rule(:pre_element => subtree(:a)) do
    RedClothParslet::Ast::Pre.new(a[:content], {:open_tag => String(a[:open_tag])})
  end
  rule(:code_element => subtree(:a)) do
    RedClothParslet::Ast::Code.new(a[:content], {:open_tag => String(a[:open_tag])})
  end
  rule(:open_tag => simple(:open_tag), :content => subtree(:content), :close_tag => simple(:close_tag)) do
    RedClothParslet::Ast::HtmlElement.new(
      content, {:open_tag => String(open_tag), :close_tag => String(close_tag)}
    )
  end
  rule(:bq => subtree(:a)) { RedClothParslet::Ast::Blockquote.new(a[:content], a[:opts]) }
  rule(:bc => subtree(:c)) { RedClothParslet::Ast::Blockcode.new(c[:content], c[:opts]) }
  rule(:list => subtree(:a)) { RedClothParslet::Ast::List.build(a[:content], a[:opts]) }
  rule(:footnote => subtree(:a)) { RedClothParslet::Ast::Footnote.new(a[:content], a[:opts]) }
  rule(:link_alias => subtree(:a)) { link_aliases[String(a[:alias])] = String(a[:href]); nil }
  rule(:raw_block => subtree(:a)) { RedClothParslet::Ast::RawBlock.new(a[:content]) }

  # tables
  rule(:thead => subtree(:h), :tfoot => subtree(:f), :tbody => subtree(:b)) do
    # sort to be HTML4-compatible
    [[:THead, h], [:TFoot, f], [:TBody, b]].inject([]) { |array, (type, s)|
      ast = lambda {|e| RedClothParslet::Ast::const_get(type).new(e[:content], e[:opts]) }
      array + (type == :TBody ? s.map{|n| ast[n]} : [ast[s]]) if s && !s.empty?
    }
  end
  # rule(:col_width => simple(:w)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new([{:style => "width:#{String(dict[:w])}"}])} }
  rule(:col_width => simple(:w), :attributes => subtree(:a)) {|dict| {:opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:style => "width:#{String(dict[:w])}"}))} }
  # rule(:col_width => simple(:w), :content => subtree(:c)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new([{:style => "width:#{String(dict[:w])}"}])} }
  rule(:col_width => simple(:w), :attributes => subtree(:a), :content => subtree(:c)) {|dict| {:content => dict[:c], :opts => RedClothParslet::Ast::Attributes.new(dict[:a].push({:style => "width:#{String(dict[:w])}"}))} }
  rule(:col_data => subtree(:a)) { RedClothParslet::Ast::Col.new([], a) }
  # rule(:colgroup => subtree(:g), :content => subtree(:c)) {|dict| {:content => dict[:c].unshift(RedClothParslet::Ast::ColGroup.new(dict[:g])), :opts => {}} }
  rule(:colgroup => subtree(:g), :content => subtree(:c), :attributes => subtree(:a)) {|dict| {:content => dict[:c].unshift(RedClothParslet::Ast::ColGroup.new(dict[:g])), :opts => RedClothParslet::Ast::Attributes.new(dict[:a])} }

  rule(:table => subtree(:a)) { RedClothParslet::Ast::Table.new(a[:content], a[:opts]) }
  rule(:table_row => subtree(:a)) { RedClothParslet::Ast::TableRow.new(a[:content], a[:opts]) }
  rule(:table_data => subtree(:a) ) do
    RedClothParslet::Ast::TableData.new(a[:content], a[:opts])
  end
  rule(:table_header => subtree(:a)) { RedClothParslet::Ast::TableHeader.new(a[:content], a[:opts]) }

  rule(:section_break => simple(:s)) { RedClothParslet::Ast::Hr.new }
  rule(:hr => subtree(:a)) { RedClothParslet::Ast::Hr.new(a[:opts]) }
  rule(:br => subtree(:a)) { RedClothParslet::Ast::Br.new(a[:opts]) }

  RedClothParslet::Parser::Inline::SIMPLE_INLINE_ELEMENTS.each do |block_type, symbol|
    rule(block_type => subtree(:a)) do
      RedClothParslet::Ast::const_get(block_type.to_s.capitalize).new(a[:content], a[:opts])
    end
  end
  rule(:double_quoted_phrase => subtree(:a)) { RedClothParslet::Ast::DoubleQuotedPhrase.new(a[:content]) }
  rule(:link => subtree(:a)) { RedClothParslet::Ast::Link.new(a[:content], a[:opts]) }
  rule(:forced_quote => subtree(:q)) { ['[', q, ']'] }
  rule(:parentheses => subtree(:a)) { ['(', a[:content], ')'] }
  rule(:image => subtree(:a)) do
    if href = a[:opts][:href]
      a[:opts] = a[:opts].reject{|k,v| k == :href}
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
