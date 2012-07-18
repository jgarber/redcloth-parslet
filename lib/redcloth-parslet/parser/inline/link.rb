class RedClothParslet::Parser::Inline < Parslet::Parser
  rule(:link) do
    (str('"') >>
      maybe_preceded_by_attributes(link_content.as(:content)).exclude(:link) >>
      end_link).as(:link)
  end

  rule(:link_content) do
    (str('(') >> link_content.exclude(:paren).as(:content) >> str(')')).as(:parentheses)|
    inline.exclude(:link)
  end

  rule(:end_link) do
    inline_sp.maybe >> link_title.maybe >> str('":') >> link_uri.as(:href)
  end

  rule(:link_title) do
    str('(') >> (str(")").absent? >> any).repeat(1).as(:title) >> str(')')
  end

  rule(:link_uri) { RedClothParslet::Parser::Attributes::LinkUri.new }
end
