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

  rule(:definition_list) { dt.repeat(2).as(:dl) }
  rule(:dt) { (str("- ") >> definition_list_content.as(:content)).as(:dt) >> dd.maybe >> dt_end }
  rule(:dd) { (spaces >> str(":=") >> spaces >> definition_list_content.as(:content)).as(:dd) }

  rule(:dt_start) { str("- ") }
  rule(:dt_end) { block_end.present? | (block_end.absent? >> str("\n") >> dt_start.present?) }

  rule(:list_content) { RedClothParslet::Parser::Inline.new.list_contents }

  rule(:definition_list_content) { RedClothParslet::Parser::Inline.new.definition_list_contents }
end
