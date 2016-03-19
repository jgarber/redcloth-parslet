class RedClothParslet::Parser::Inline < Parslet::Parser
  rule(:image) do
    (str('!') >> 
    maybe_preceded_by_attributes(image_uri.as(:src)) >> 
    image_alt.maybe >>
    end_image).as(:image)
  end

  rule(:image_alt) do
    str("(") >> (
      str(")!").absent? >> (
        str("(").present? >> alt_parenthesized | match("[^(]")
      )
    ).repeat.as(:alt) >>
    str(")")
  end
  rule(:alt_parenthesized) do
    str("(") >> (
      str(")!").absent? >>
      (str(")") >> match("[^)!]").repeat(1) >> str(")!")).absent? >>
      any
    ).repeat >>
    str(")!").absent? >> str(")")
  end

  rule(:end_image) do
    str('!:') >> link_uri.as(:href) |
    str('!') >> match("[a-zA-Z0-9]").absent?
  end

  rule(:image_uri) { RedClothParslet::Parser::Attributes::ImageUri.new }
end
