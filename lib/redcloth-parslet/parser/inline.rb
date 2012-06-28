class RedClothParslet::Parser::Inline < Parslet::Parser
  include RedClothParslet::Parser::Common

  root(:inline)
  rule(:inline) do
    sp.absent? >>
    inline_element.repeat(1)
  end

  SIMPLE_INLINE_ELEMENTS = [
    [:b, '**'],
    [:i, '__'],
    [:strong, '*'],
    [:em, '_'],
    [:span, '%'],
    [:ins, '+'],
    [:del, '-'],
    [:code, '@'],
    [:sup, '^'],
    [:sub, '~'],
    [:cite, '??']
  ]
  
  # Inline elements are terms (words) divided by spaces or spaces themselves.
  # Sometimes terms are contiguous, such as <code>*bold*.</code> (bold phrase 
  # followed by a period, which is a word).
  rule(:inline_element) do
    standalone_en_dash |
    standalone_symbol_from_simple_inline_element |
    space_between_terms |
    term
  end

  rule(:space_between_terms) do
    sp.as(:s) >> term.present?
  end
  
  rule(:list_contents) do
    inline.exclude(:li_start)
  end
  
  rule(:table_contents) do
    (inline_element.exclude(:table_cell_start) | inline_sp.as(:s)).repeat(1)
  end
  
  rule(:sovereign_term) do
    typographic_entity |
    image |
    link |
    double_quoted_phrase |
    simple_inline_term |
    parenthesized_sovereign_term |
    acronym |
    all_caps_word |
    dimensions |
    html_tag
  end

  rule(:forced_inline_term) do
    (str("[") >> double_quoted_phrase >> str("]")).as(:forced_quote) |
    forced_simple_inline_term |
    str("[") >> sovereign_term >> str("]")
  end

  rule(:term) do
    code_tag |
    sovereign_term |
    forced_inline_term |
    word
  end
  
  rule(:simple_inline_term) do
    SIMPLE_INLINE_ELEMENTS.map {|el,mark| send(el).unless_excluded(el) }.reduce(:|)
  end

  rule(:simple_inline_term_end_exclusion) do
    SIMPLE_INLINE_ELEMENTS.map {|el,mark| send("end_#{el}").absent?.if_excluded(el) }.reduce(:>>)
  end

  rule(:standalone_symbol_from_simple_inline_element) do
    SIMPLE_INLINE_ELEMENTS.map {|el,mark| (inline_sp >> (typographic_entity >> sp).absent? >> str(mark).repeat(1)).as(:s) >> sp.present? }.reduce(:|)
  end

  # general pattern for inline elements
  SIMPLE_INLINE_ELEMENTS.each do |element_name, signature|
    end_rule_name = "end_#{element_name}".to_sym
    rule(element_name) do
      (str(signature) >>
      maybe_preceded_by_attributes(inline.exclude(element_name).exclude(:newline).as(:content)) >> 
      send(end_rule_name)).as(element_name)
    end
    rule(end_rule_name) { str(signature) >> match("[a-zA-Z0-9]").absent? }
  end
  # exceptions to above pattern
  rule(:code) do
    (str('@') >> 
        maybe_preceded_by_attributes(code_words.as(:content)) >>
        end_code).as(:code)
  end
  rule(:end_strong) { str('*') >> match("[a-zA-Z0-9*]").absent? }
  rule(:end_em) { str('_') >> match("[a-zA-Z0-9_]").absent? }
  rule(:end_cite) { str('??') >> match("[a-zA-Z0-9?]").absent? }

  rule(:forced_simple_inline_term) do
    SIMPLE_INLINE_ELEMENTS.map {|el,mark| send("forced_#{el}").unless_excluded(el) }.reduce(:|)
  end
  SIMPLE_INLINE_ELEMENTS.each do |element_name, signature|
    rule_name = "forced_#{element_name}"
    end_rule_name = "end_#{rule_name}"
    rule(rule_name) do
      (str("[") >> str(signature) >>
      maybe_preceded_by_attributes((
        (send(end_rule_name).absent? >> any).repeat(1).as(:s)
      ).as(:content)) >>
      send(end_rule_name)).as(element_name)
    end
    rule(end_rule_name) { str(signature) >> str("]") }
  end

  rule(:parenthesized_sovereign_term) { (str('(') >> sovereign_term.as(:content) >> str(')')).as(:parentheses) }
  
  rule(:code_tag) do
    (str('<code>') >> 
        ((end_code_tag.absent? >> any).repeat(1).as(:s)).as(:content) >>
        end_code_tag).as(:code)
  end
  rule(:end_code_tag) { str("</code>") }

  rule(:double_quoted_phrase) do
    # Nesting can cause sequential quotes or links with the second starting with
    # a colon, so we have to negate that case to get nesting to work.
    (str('"') >> str(':').absent? >>
      maybe_preceded_by_attributes(inline.exclude(:double_quoted_phrase).as(:content)) >>
      end_double_quoted_phrase).as(:double_quoted_phrase)
  end
  rule(:end_double_quoted_phrase) do
    str('"')
  end

  rule(:link) do
    (str('"') >> 
      maybe_preceded_by_attributes(inline.exclude(:link).as(:content)) >>
      end_link).as(:link)
  end
  rule(:end_link) do
    link_title.maybe >> str('":') >> link_uri.as(:href)
  end
  rule(:link_title) do
    str('(') >> inline.exclude(:paren).as(:title) >> str(')')
  end
  
  rule(:image) do
    (str('!') >> 
    maybe_preceded_by_attributes(image_uri.as(:src)) >> 
    image_alt.maybe >>
    end_image).as(:image)
  end
  rule(:image_alt) { str("(") >> (str(")").absent? >> any).repeat(1).as(:alt) >> str(")") }
  rule(:end_image) do
    str('!:') >> link_uri.as(:href) |
    (str('!') >> match("[a-zA-Z0-9]").absent?)
  end
  
  rule(:acronym) do
    (
      match("[A-Z]").as(:s).repeat(1).as(:content) >> 
      (str('(') >>  
        (str(')').absent? >> any).repeat(1).as(:title) >> 
        str(')')
      ).as(:attributes)
    ).as(:acronym)
  end

  rule(:all_caps_word) { match("[A-Z]").repeat(3).as(:caps) }
  
  rule(:dimensions) do
    (dimension | factor.as(:s)).as(:left) >> 
    inline_sp?.as(:left_space) >>
    str('x').as(:entity) >> 
    inline_sp?.as(:right_space) >> 
    ((dimensions | dimension | factor.as(:s))).as(:right)
  end
  rule(:dimension) do
    ( factor >> match(%q{['"]}) ).repeat(1).as(:dimension)
  end
  rule(:factor) { digits >> (match('[.,/ -]') >> digits).repeat }
  
  rule(:typographic_entity) do
    m_dash |
    ip_mark |
    ellipsis
  end

  rule(:ip_mark) { (str("(") >> (stri("tm") | stri("c") | stri("r")) >> str(")")).as(:entity) }
  rule(:m_dash) { str('--').as(:entity) >> str('-').repeat }
  rule(:ellipsis) { str('...').as(:entity) }
  rule(:standalone_en_dash) { (inline_sp >> str('-')).as(:entity) >> sp.present? }
  
  rule :word do
    char = (exclude_significant_end_characters >> mchar)
    char.repeat(1).as(:s) >> footnote_reference.maybe
  end
  rule :exclude_significant_end_characters do
    html_tag.absent? >>
    forced_inline_term.absent? >>
    footnote_reference.absent? >>
    # TODO: make this the same rule as in parser/block/lists.rb so it's DRY.
    (match("[*#]").repeat(1) >> str(" ")).absent?.if_excluded(:li_start) >>
    # TODO: make this the same rule as in parser/block/tables.rb so it's DRY.
    str("|").absent?.if_excluded(:table_cell_start) >>
    str(')').absent?.if_excluded(:paren) >>
    (str('"') | end_link).absent?.if_excluded(:link) >>
    end_double_quoted_phrase.absent?.if_excluded(:double_quoted_phrase) >>
    simple_inline_term_end_exclusion
  end
  
  rule :footnote_reference do
    str("[") >> digits.as(:footnote_reference) >> str("]")
  end

  rule(:code_words) do
    (code_chars >> 
      (match('\s+') >> 
        (code_chars)
      ).repeat
    ).as(:s)
  end
  rule(:code_chars) { (end_code.absent? >> match('\S')).repeat(1) | (str('@') >> match('\s').present?) }
  rule(:mchar) { typographic_entity.absent? >> match('\S') }
  rule(:inline_sp) { match('[ \t]').repeat(1) }
  rule(:inline_sp?) { inline_sp.maybe }
  rule(:sp) { inline_sp | str("\n").unless_excluded(:newline) }
  # rule(:mtext) { mchar.repeat(1) >> (inline_sp >> mchar.repeat(1)) }
  
  rule(:image_uri) { RedClothParslet::Parser::Attributes::ImageUri.new }
  rule(:link_uri) { RedClothParslet::Parser::Attributes::LinkUri.new }
  rule(:html_tag) { RedClothParslet::Parser::HtmlTag.new }

  def maybe_preceded_by_attributes(content_rule)
    attributes?.as(:attributes) >> content_rule |
    content_rule
  end

  rule(:attributes?) { RedClothParslet::Parser::Attributes.new.attribute.repeat }
end
