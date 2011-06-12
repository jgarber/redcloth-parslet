class RedClothParslet::Parser::Inline < Parslet::Parser
  root(:inline)
  rule(:inline) do
    inline_sp.absent? >>
    inline_element.repeat(1)
  end
  
  # Inline elements are terms (words) divided by spaces or spaces themselves.
  rule(:inline_element) do
    inline_sp.as(:s) >> term.present? |
    (inline_sp >> str('*')).as(:s) >> inline_sp.present? |
    (inline_sp >> str('_')).as(:s) >> inline_sp.present? |
    term
  end
  
  rule(:term) do
    link.unless_excluded(:link) |
    bold.unless_excluded(:bold) |
    italics.unless_excluded(:italics) |
    strong.unless_excluded(:strong) |
    em.unless_excluded(:em) |
    word.as(:s)
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
  
  rule(:link) do
    (str('"') >> 
    maybe_preceded_by_attributes(inline.exclude(:link).as(:content)) >> 
    end_link).as(:link)
  end
  rule(:end_link) { str('":') >> nongreedy_uri.as(:href) }
  
  rule :word do
    char = (exclude_significant_end_characters >> mchar)
    char.repeat(1)
  end
  rule :exclude_significant_end_characters do
    end_link.absent?.if_excluded(:link) >>
    end_bold.absent?.if_excluded(:bold) >>
    end_italics.absent?.if_excluded(:italics) >>
    end_strong.absent?.if_excluded(:strong) >>
    end_em.absent?.if_excluded(:em)
  end

  rule(:mchar) { match('\S') }
  rule(:inline_sp) { match('[ \t]').repeat(1) | str("\n") }
  
  rule(:nongreedy_uri) { RedClothParslet::Parser::Attributes::NongreedyUri.new }

  def maybe_preceded_by_attributes(content_rule)
    attributes?.as(:attributes) >> content_rule |
    content_rule
  end

  rule(:attributes?) { RedClothParslet::Parser::Attributes.new.attribute.repeat }
end