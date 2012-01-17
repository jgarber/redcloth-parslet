class RedClothParslet::Parser::Inline < Parslet::Parser
  root(:inline)
  rule(:inline) do
    sp.absent? >>
    inline_element.repeat(1)
  end
  
  # Inline elements are terms (words) divided by spaces or spaces themselves.
  rule(:inline_element) do
    standalone_en_dash |
    sp.as(:s) >> term.present? |
    standalone_asterisk |
    standalone_underscore |
    standalone_percent |
    standalone_plus |
    term
  end
  
  rule(:list_contents) do
    inline.exclude(:li_start)
  end
  
  rule(:table_contents) do
    inline.exclude(:table_cell_start)
  end
  
  rule(:term) do
    entity |
    image |
    double_quoted_phrase_or_link |
    bold.unless_excluded(:bold) |
    italics.unless_excluded(:italics) |
    strong.unless_excluded(:strong) |
    em.unless_excluded(:em) |
    span.unless_excluded(:span) |
    ins.unless_excluded(:ins) |
    acronym |
    dimensions |
    word.as(:s)
  end
  
  rule(:entity) do
    m_dash |
    ellipsis
  end
  
  rule(:bold) do
    (str('**') >>
    maybe_preceded_by_attributes(inline.exclude(:bold).as(:content)) >> 
    end_bold).as(:b)
  end
  rule(:end_bold) { str('**') >> match("[a-zA-Z0-9]").absent? }
  
  rule(:italics) do
    (str('__') >>
    maybe_preceded_by_attributes(inline.exclude(:italics).as(:content)) >> 
    end_italics).as(:i)
  end
  rule(:end_italics) { str('__') >> match("[a-zA-Z0-9]").absent? }
  
  rule(:strong) do
    (str('*') >>
    maybe_preceded_by_attributes(inline.exclude(:strong).as(:content)) >> 
    end_strong).as(:strong)
  end
  rule(:end_strong) { str('*') >> match("[a-zA-Z0-9]").absent? }
  
  rule(:em) do
    (str('_') >> 
    maybe_preceded_by_attributes(inline.exclude(:em).as(:content)) >> 
    end_em).as(:em)
  end
  rule(:end_em) { str('_') >> match("[a-zA-Z0-9]").absent? }

  rule(:span) do
    (str('%') >> 
    maybe_preceded_by_attributes(inline.exclude(:span).as(:content)) >> 
    end_span).as(:span)
  end
  rule(:end_span) { str('%') >> match("[a-zA-Z0-9]").absent? }

  rule(:ins) do
    (str('+') >> 
    maybe_preceded_by_attributes(inline.exclude(:ins).as(:content)) >> 
    end_ins).as(:ins)
  end
  rule(:end_ins) { str('+') >> match("[a-zA-Z0-9]").absent? }

  rule(:double_quoted_phrase_or_link) do
      (str('"') >>
      maybe_preceded_by_attributes(inline.exclude(:double_quoted_phrase_or_link).as(:content)) >>
      end_double_quoted_phrase_or_link).as(:double_quoted_phrase_or_link)
  end
  rule(:end_double_quoted_phrase_or_link) do
    str('":') >> nongreedy_uri.as(:href) |
    str('"')
  end
  
  rule(:image) do
    (str('!') >> 
    maybe_preceded_by_attributes(nongreedy_uri.as(:src)) >> 
    image_alt.maybe >>
    end_image).as(:image)
  end
  rule(:image_alt) { str("(") >> (str(")").absent? >> any).repeat(1).as(:alt) >> str(")") }
  rule(:end_image) do
    str('!:') >> nongreedy_uri.as(:href) |
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
  
  rule(:m_dash) { str('--').as(:entity) }
  rule(:ellipsis) { str('...').as(:entity) }
  rule(:standalone_asterisk)   { (inline_sp >> str('*')).as(:s) >> sp.present? }
  rule(:standalone_underscore) { (inline_sp >> str('_')).as(:s) >> sp.present? }
  rule(:standalone_plus) { (inline_sp >> str('+')).as(:s) >> sp.present? }
  rule(:standalone_percent) { (inline_sp >> str('%')).as(:s) >> sp.present? }
  rule(:standalone_en_dash) { (inline_sp >> str('-')).as(:entity) >> sp.present? }
  
  rule :word do
    char = (exclude_significant_end_characters >> mchar)
    char.repeat(1)
  end
  rule :exclude_significant_end_characters do
    # TODO: make this the same rule as in parser/block/lists.rb so it's DRY.
    (match("[*#]").repeat(1) >> str(" ")).absent?.if_excluded(:li_start) >>
    # TODO: make this the same rule as in parser/block/tables.rb so it's DRY.
    str("|").absent?.if_excluded(:table_cell_start) >>
    match('[":]').absent?.if_excluded(:double_quoted_phrase_or_link) >>
    end_bold.absent?.if_excluded(:bold) >>
    end_italics.absent?.if_excluded(:italics) >>
    end_strong.absent?.if_excluded(:strong) >>
    end_em.absent?.if_excluded(:em) >>
    end_ins.absent?.if_excluded(:ins) >>
    end_span.absent?.if_excluded(:span)
  end

  rule(:mchar) { entity.absent? >> match('\S') }
  rule(:inline_sp) { match('[ \t]').repeat(1) }
  rule(:inline_sp?) { inline_sp.maybe }
  rule(:sp) { inline_sp | str("\n") }
  rule(:digits) { match('[0-9]').repeat(1) }
  # rule(:mtext) { mchar.repeat(1) >> (inline_sp >> mchar.repeat(1)) }
  
  rule(:nongreedy_uri) { RedClothParslet::Parser::Attributes::NongreedyUri.new }

  def maybe_preceded_by_attributes(content_rule)
    attributes?.as(:attributes) >> content_rule |
    content_rule
  end

  rule(:attributes?) { RedClothParslet::Parser::Attributes.new.attribute.repeat }
end