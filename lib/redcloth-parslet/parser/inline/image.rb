class RedClothParslet::Parser::Inline < Parslet::Parser
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

  rule(:image_uri) { RedClothParslet::Parser::Attributes::ImageUri.new }
end
