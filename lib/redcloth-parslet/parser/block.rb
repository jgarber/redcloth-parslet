class RedClothParslet::Parser::Block < Parslet::Parser
  root(:textile_doc)
  rule(:textile_doc) do
    block_element.repeat(1)
  end
  
  rule(:block_element) do
    notextile_block_tags |
    notextile_block |
    paragraph
  end
  
  rule(:notextile_block) { (str("notextile. ") >> (block_end.absent? >> any).repeat.as(:s) >> block_end).as(:notextile) }
  rule(:notextile_block_tags) { (str("<notextile>\n") >> (notextile_block_end_tag.absent? >> any).repeat.as(:s) >> notextile_block_end_tag >> block_end).as(:notextile) }
  rule(:notextile_block_end_tag) { str("\n</notextile>") }
  
  rule(:paragraph) { (explicit_paragraph | undecorated_paragraph).as(:p) }
  rule(:explicit_paragraph) { str("p") >> attributes?.as(:attributes) >> str(". ") >> content.as(:content) >> block_end }
  rule(:undecorated_paragraph) { content.as(:content) >> block_end }
  
  rule(:content) { RedClothParslet::Parser::Inline.new }
  
  rule(:attributes?) { RedClothParslet::Parser::Attributes.new.attribute.repeat }
  
  rule(:eof) { any.absent? }
  rule(:block_end) { eof | double_newline }
  rule(:double_newline) { str("\n") >> match("[\s\t]").repeat >> str("\n") }
end