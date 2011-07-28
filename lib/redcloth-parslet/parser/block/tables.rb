class RedClothParslet::Parser::Block < Parslet::Parser
  
  rule(:table) do
    (
      # attributes?.as(:attributes) >> 
      table_row.repeat(1).as(:content) >> 
      block_end
    ).as(:table)
  end
  
  rule(:table_row) do
    ( table_data.repeat(1).as(:content) >> end_table_row ).as(:table_row)
  end
  rule(:end_table_row) { block_end.present? | (block_end.absent? >> str("|\n") >> table_row.present?) }
  
  rule(:table_data) do
    str("|") >> (str("one") | str("two") | str("three")).as(:content) #inline.as(:content)
  end
  
  # TODO: This isn't working yet
end