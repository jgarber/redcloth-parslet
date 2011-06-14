class RedClothParslet::Parser::Block < Parslet::Parser
  
  rule(:list) do
    (
      attributes?.as(:attributes) >> 
      li.repeat(1).as(:content) >> 
      block_end
    ).as(:list)
  end
  
  rule(:li) { li_start >> list_content.as(:content) >> li_end }
  
  rule(:li_start) { match("[*#]").repeat(1).as(:layout) >> attributes?.as(:attributes) >> str(" ") }
  rule(:li_end) { block_end.present? | (block_end.absent? >> str("\n") >> li_start.present?) }
  
  rule(:list_content) { RedClothParslet::Parser::Inline.new.list_contents }
end