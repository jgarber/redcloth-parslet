class RedClothParslet::Parser::Block < Parslet::Parser
  
  rule(:table) do
    (
      (str("table") >> attributes?.as(:attributes) >> str(".\n")).maybe >>
      table_row.repeat(1).as(:content) >> 
      block_end
    ).as(:table)
  end
  
  rule(:table_row) do
    ( (table_header | table_data).repeat(1).as(:content) >> end_table_row ).as(:table_row)
  end
  rule(:end_table_row) { str("|") >> (block_end.present? | (str("\n") >> table_row.present?)) }
  
  rule(:table_header) do
    (str("|_. ") >> table_content.as(:content)).as(:table_header)
  end
  rule(:table_data) do
    (str("|") >> table_attributes? >> table_content.as(:content)).as(:table_data)
  end
  
  rule(:table_content) { RedClothParslet::Parser::Inline.new.table_contents }
  rule(:table_attributes?) do
    (RedClothParslet::Parser::Attributes.new.table_attributes >>
    str(".") >> match("[\t ]")).as(:attributes).maybe
  end

  rule(:spaces) { match("[\t ]").repeat }
  
end
