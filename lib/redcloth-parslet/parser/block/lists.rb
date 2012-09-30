class RedClothParslet::Parser::Block < Parslet::Parser
  
  rule(:list) do
    (
      attributes?.as(:attributes) >> 
      li.repeat(2).as(:content) >> 
      block_end
    ).as(:list)
  end
  
  rule(:li) { li_start >> list_content.as(:content) >> li_end }
  
  rule(:li_start) do
    match("[*#]").repeat(1).as(:layout) >>
    (digits | str("_")).maybe.as(:continuation) >>
    attributes?.as(:attributes) >>
    str(" ")
  end
  rule(:li_end) { block_end.present? | (block_end.absent? >> str("\n") >> li_start.present?) }

  rule(:definition_list) { definition.repeat(1).as(:dl) }
  rule(:definition) { dt >> (dt_end >> dt).repeat >> spaces >> dd >> definition_end }
  rule(:dt) { (str("- ") >> definition_list_content.as(:content)).as(:dt) }
  rule(:dd) { (str(":=") >> spaces >> definition_list_content.as(:content)).as(:dd) }

  rule(:dt_start) { str("- ") }
  rule(:dt_end) { block_end.absent? >> str("\n") >> dt_start.present? }
  rule(:definition_end) { block_end.present? | dt_end }

  rule(:list_content) { RedClothParslet::Parser::Inline.new.list_contents }

  rule(:definition_list_content) { RedClothParslet::Parser::Inline.new.definition_list_contents }
end
