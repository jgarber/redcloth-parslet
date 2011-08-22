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
  rule(:end_table_row) { str("|") >> (block_end.present? | (str("\n") >> table_row.present?)) }
  
  rule(:table_data) do
    (str("|") >> table_content.as(:content)).as(:table_data)
  end
  
  rule(:table_content) { RedClothParslet::Parser::Inline.new.table_contents }
  
end