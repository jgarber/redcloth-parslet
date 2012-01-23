class RedClothParslet::Parser::Block < Parslet::Parser
  root(:textile_doc)
  rule(:textile_doc) do
    block_element.repeat(1)
  end

  rule(:block_element) do
    block_html_tag |
    list |
    table |
    simple_block_elements |
    notextile_block_tags |
    notextile_block |
    extended_blockquote |
    blockquote |
    undecorated_paragraph
  end

  SIMPLE_BLOCK_ELEMENTS = [:div, :p] +
    1.upto(6).map {|n| :"h#{n}" } # Heading levels 1-6

  rule(:simple_block_elements) do
    SIMPLE_BLOCK_ELEMENTS.map do |block_type|
      [send(block_type), send("extended_#{block_type}s")]
    end.flatten.reduce(:|)
  end

  SIMPLE_BLOCK_ELEMENTS.each do |block_type|
    rule("extended_#{block_type}s") { (((str(block_type) >> attributes?.as(:attributes) >> str(".. ") >> content.as(:content) >> block_end).as(block_type)).as(:first) >> ((extended_block_end.absent? >> undecorated_block.as(block_type)).repeat(1)).as(:successive) >> extended_block_end).as(:extended) }
    rule(block_type) { (str(block_type) >> attributes?.as(:attributes) >> str(". ") >> content.as(:content) >> block_end).as(block_type) }
  end

  rule(:notextile_block) { (str("notextile. ") >> (block_end.absent? >> any).repeat.as(:s) >> block_end).as(:notextile) }
  rule(:notextile_block_tags) { (str("<notextile>\n") >> (notextile_block_end_tag.absent? >> any).repeat.as(:s) >> notextile_block_end_tag >> block_end).as(:notextile) }
  rule(:notextile_block_end_tag) { str("\n</notextile>") }

  rule(:blockquote) { (str("bq") >> attributes?.as(:attributes) >> str(". ") >> (undecorated_paragraph).as(:content)).as(:bq) }
  rule(:extended_blockquote) { (str("bq") >> attributes?.as(:attributes) >> str(".. ") >> (undecorated_paragraph.repeat(1)).as(:content) >> extended_block_end).as(:bq) }

  rule(:undecorated_block) { content.as(:content) >> block_end }
  rule(:undecorated_paragraph) { undecorated_block.as(:p) }

  rule(:content) { RedClothParslet::Parser::Inline.new }
  rule(:block_html_tag) { RedClothParslet::Parser::BlockHtmlTag.new >> (str("\n").repeat(1) | eof) }

  rule(:attributes?) { RedClothParslet::Parser::Attributes.new.attribute.repeat }

  rule(:eof) { any.absent? }
  rule(:block_end) { eof | double_newline }
  rule(:extended_block_end) { (eof | next_block_start).present? }
  rule(:next_block_start) { match("[a-z]").repeat(1) >> attributes? >> (str('. ') | str('.. ')) }
  rule(:double_newline) { str("\n") >> (match("[\s\t]").repeat >> str("\n")).repeat(1) }
end

require 'redcloth-parslet/parser/block/lists'
require 'redcloth-parslet/parser/block/tables'
