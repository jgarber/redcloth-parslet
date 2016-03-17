class RedClothParslet::Parser::Block < Parslet::Parser
  
  rule(:table) do
    (
      (str("table") >> attributes?.as(:attributes) >> str(".") >> blank).maybe >>
      colgroup.as(:colgroup).maybe >>
      (
        thead.maybe.as(:thead) >> (tfoot.maybe.as(:tfoot) >> tbody.repeat(1).as(:tbody) | tbody.repeat(1).as(:tbody) >> tfoot.maybe.as(:tfoot)) |
        table_row.repeat(1)
      ).as(:content) >>
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
    (str("|_") >> (td_attributes | dotspace) >> table_content.as(:content)).as(:table_header)
  end
  rule(:table_data) do
    (str("|") >> str("\n").absent? >> td_attributes? >> table_content.as(:content)).as(:table_data)
  end
  rule(:col_data) do
    (str("|") >> str("\n").absent? >> td_attributes? >> col_width).as(:col_data)
  end

  rule(:thead) do
    thead_start >> table_row.repeat.as(:content) >> (tfoot_start | tbody_start).present?
  end
  rule(:tfoot) do
    tfoot_start >> table_row.repeat.as(:content) >> (tbody_start | block_end).present?
  end
  rule(:tbody) do
    tbody_start >> table_row.repeat.as(:content) >> (tbody_start | tfoot_start | block_end).present?
  end
  rule(:thead_start) { str("|^") >> tsections_format }
  rule(:tfoot_start) { str("|~") >> tsections_format }
  rule(:tbody_start) { str("|-") >> tsections_format }
  rule(:tsections_format) { (td_attributes | dotspace) >> (blank | spaces >> str("|").present?) }

  rule(:colgroup) do
    colgroup_start >> table_data.repeat.as(:content) >> end_table_row >> (thead_start | tfoot_start | tbody_start | table_row | block_end).present?
  end
  rule(:colgroup_start) { str("|:") >> (td_attributes | dotspace) >> col_width >> (blank | spaces >> str("|").present?) }
  rule(:col_width) { match("[0-9a-z]").repeat(1).as(:col_width).maybe }
  
  rule(:table_content) { RedClothParslet::Parser::Inline.new.table_contents }
  rule(:td_attributes) do
    (RedClothParslet::Parser::Attributes.new.td_attributes >> dotspace
    ).as(:attributes)
  end
  rule(:td_attributes?) { td_attributes.maybe }
  rule(:dotspace) { str(".") >> match("[\t ]").maybe }
end
