class RedClothParslet::Parser::Block < Parslet::Parser
  
  rule(:list) do
    (
      attributes?.as(:attributes) >> 
      li.repeat(1).as(:content) >> # Why this was @repeat(2)@?
      basic_block_end
    ).as(:list)
  end
  
  rule(:li) { spaces >> li_start >> list_content.as(:content) >> li_end }
  
  rule(:li_start) do
    (
      (((str("#") >> (digits | str("_"))).absent? >>
      match("[*#]")).repeat >> str("#")).as(:layout) >>
      (digits | str("_")).as(:continuation) |
      match("[*#]").repeat(1).as(:layout)
    ) >>
    attributes?.as(:attributes) >>
    str(" ")
  end
  rule(:li_end) { basic_block_end.present? | (basic_block_end.absent? >> str("\n") >> li_start.present?) }

  rule(:definition_list) { definition.repeat(1).as(:dl) }
  rule(:definition) { dt >> (dt_end >> dt).repeat >> spaces >> dd >> definition_end }
  rule(:dt) { (dt_start >> definition_list_content.as(:content)).as(:dt) }
  rule(:dd) { (dd_start >> spaces >> definition_list_content.as(:content)).as(:dd) }

  rule(:dt_start) { str("- ") }
  rule(:dd_start) { str(":=") }
  rule(:dt_end) { basic_block_end.absent? >> str("\n") >> dt_start.present? }
  rule(:definition_end) { basic_block_end.present? | dt_end }

  rule(:list_content) { RedClothParslet::Parser::Inline.new.list_contents }

  rule(:definition_list_content) { RedClothParslet::Parser::Inline.new.definition_list_contents }
end
