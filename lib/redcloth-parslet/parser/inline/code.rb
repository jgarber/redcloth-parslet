class RedClothParslet::Parser::Inline < Parslet::Parser
  rule(:code) do
    (str('@') >> 
        maybe_preceded_by_attributes(code_words.as(:content)) >>
        end_code).as(:code)
  end
  # end_code is generated from the inclusion of @ in SIMPLE_INLINE_ELEMENTS

  rule(:code_tag) do
    (str('<code>') >> 
        ((end_code_tag.absent? >> any).repeat(1).as(:s)).as(:content) >>
        end_code_tag).as(:code)
  end
  rule(:end_code_tag) { str("</code>") }

  rule(:code_words) do
    (code_chars >> 
      (match('\s+') >> 
        (code_chars)
      ).repeat
    ).as(:s)
  end
  rule(:code_chars) { (end_code.absent? >> match('\S')).repeat(1) | (str('@') >> match('\s').present?) }
end
