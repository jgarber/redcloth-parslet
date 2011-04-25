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
    strong.unless_excluded(:strong) |
    em.unless_excluded(:em) |
    word.as(:s)
  end
  
  rule(:strong) do
    str('*').as(:inline) >>
    inline.exclude(:strong).as(:content) >> 
    end_strong
  end
  rule(:end_strong) { str('*') >> match("[a-zA-Z0-9]").absent? }
  
  rule(:em) do
    (str('_').as(:inline) >> 
    inline.exclude(:em).as(:content) >> 
    end_em)
  end
  rule(:end_em) { str('_') >> match("[a-zA-Z0-9]").absent? }
  
  rule :word do
    char = (exclude_significant_end_characters >> mchar)
    char.repeat(1)
  end
  rule :exclude_significant_end_characters do
    end_strong.absent?.if_excluded(:strong) >>
    end_em.absent?.if_excluded(:em)
  end

  rule(:mchar) { match('\S') }
  rule(:inline_sp?) { inline_sp.repeat }
  rule(:inline_sp) { match('[ \t]').repeat(1) }
end