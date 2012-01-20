class RedClothParslet::Parser::Block < Parslet::Parser
  root(:textile_doc)
  rule(:textile_doc) do
    block_element.repeat(1)
  end
  
  rule(:block_element) do
    list |
    table |
    heading |
    extended_divs |
    div |
    notextile_block_tags |
    notextile_block |
    extended_blockquote |
    blockquote |
    extended_paragraphs |
    paragraph
  end
  
  rule(:heading) { str("h") >> match("[1-6]").as(:level) >> (attributes?.as(:attributes) >> str(". ") >> content.as(:content) >> block_end).as(:heading) }
  
  rule(:notextile_block) { (str("notextile. ") >> (block_end.absent? >> any).repeat.as(:s) >> block_end).as(:notextile) }
  rule(:notextile_block_tags) { (str("<notextile>\n") >> (notextile_block_end_tag.absent? >> any).repeat.as(:s) >> notextile_block_end_tag >> block_end).as(:notextile) }
  rule(:notextile_block_end_tag) { str("\n</notextile>") }
  
  rule(:blockquote) { (str("bq") >> attributes?.as(:attributes) >> str(". ") >> (undecorated_paragraph).as(:content)).as(:bq) }
  rule(:extended_blockquote) { (str("bq") >> attributes?.as(:attributes) >> str(".. ") >> (undecorated_paragraph.repeat(1)).as(:content) >> extended_block_end).as(:bq) }


  rule(:extended_divs) { (((str("div") >> attributes?.as(:attributes) >> str(".. ") >> content.as(:content) >> block_end).as(:div)).as(:first) >> ((extended_block_end.absent? >> undecorated_block.as(:div)).repeat(1)).as(:successive) >> extended_block_end).as(:extended) }
  rule(:div) { (str("div") >> attributes?.as(:attributes) >> str(". ") >> content.as(:content) >> block_end).as(:div) }

  rule(:extended_paragraphs) { (((str("p") >> attributes?.as(:attributes) >> str(".. ") >> content.as(:content) >> block_end).as(:p)).as(:first) >> ((extended_block_end.absent? >> undecorated_block.as(:p)).repeat(1)).as(:successive) >> extended_block_end).as(:extended) }
  rule(:paragraph) { explicit_paragraph | undecorated_paragraph }
  rule(:explicit_paragraph) { (str("p") >> attributes?.as(:attributes) >> str(". ") >> content.as(:content) >> block_end).as(:p) }
  rule(:undecorated_paragraph) { undecorated_block.as(:p) }
  
  rule(:undecorated_block) { content.as(:content) >> block_end }
  
  rule(:content) { RedClothParslet::Parser::Inline.new }
  
  rule(:attributes?) { RedClothParslet::Parser::Attributes.new.attribute.repeat }
  
  rule(:eof) { any.absent? }
  rule(:block_end) { eof | double_newline }
  rule(:extended_block_end) { (eof | block_start).present? }
  rule(:block_start) { str("p. ") } # FIXME: this is just a placeholder
  rule(:double_newline) { str("\n") >> match("[\s\t]").repeat >> str("\n") }
end

require 'redcloth-parslet/parser/block/lists'
require 'redcloth-parslet/parser/block/tables'
