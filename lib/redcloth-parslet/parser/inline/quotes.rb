class RedClothParslet::Parser::Inline < Parslet::Parser
  rule(:double_quoted_phrase) do
    # Nesting can cause sequential quotes or links with the second starting with
    # a colon, so we have to negate that case to get nesting to work.
    (str('"') >> str(':').absent? >>
      inline.exclude(:double_quoted_phrase).as(:content) >>
      end_double_quoted_phrase).as(:double_quoted_phrase)
  end
  rule(:end_double_quoted_phrase) do
    str('"')
  end
end
