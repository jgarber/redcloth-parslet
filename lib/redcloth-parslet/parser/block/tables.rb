class RedClothParslet::Parser::Block < Parslet::Parser
  
  rule(:table) do
    (
      (str("table") >> attributes?.as(:attributes) >> str(".\n")).maybe >>
      table_row.repeat(1).as(:content) >> 
      block_end
    ).as(:table)
  end
  
  rule(:table_row) do
    (
      table_row_attributes >> table_row_content >>
      end_table_row
    ).as(:table_row)
  end
  rule(:table_row_attributes) { (attributes?.as(:attributes) >> str(". ")).maybe }
  rule(:table_row_content) { (table_header | table_data).repeat(1).as(:content) }
  rule(:end_table_row) { str("|") >> (block_end.present? | (str("\n"))) }
  
  rule(:table_header) do
    (str("|_. ") >> table_content.as(:content)).as(:table_header)
  end
  rule(:table_data) do
    (str("|") >> str("\n").absent? >> td_attributes? >> table_content.as(:content)).as(:table_data)
  end
  
  rule(:table_content) { (end_table_row.absent? >> RedClothParslet::Parser::Inline.new.inline_element.exclude(:table_cell_start) | inline_sp.as(:s)).repeat(1) }
  rule(:td_attributes?) do
    (RedClothParslet::Parser::Attributes.new.td_attributes >>
    str(".") >> match("[\t ]")).as(:attributes).maybe
  end

  rule(:inline_sp) { match('[ \t]').repeat(1) }
  
end
