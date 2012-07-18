class RedClothParslet::Parser::Inline < Parslet::Parser
  rule(:standalone_symbol_from_simple_inline_element) do
    SIMPLE_INLINE_ELEMENTS.map {|el,mark| (inline_sp >> (typographic_entity >> sp).absent? >> str(mark).repeat(1)).as(:s) >> sp.present? }.reduce(:|)
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

  rule(:typographic_entity) do
    m_dash |
    ip_mark |
    ellipsis
  end

  rule(:ip_mark) { (str("(") >> (stri("tm") | stri("c") | stri("r")) >> str(")")).as(:entity) }
  rule(:m_dash) { str('--').as(:entity) >> str('-').repeat }
  rule(:ellipsis) { str('...').as(:entity) }
  rule(:standalone_en_dash) { (inline_sp >> str('-')).as(:entity) >> sp.present? }
end
