class RedClothParslet::Parser::Block < Parslet::Parser
  include RedClothParslet::Parser::Common
  require 'pry-byebug'

  root(:textile_doc)
  rule(:textile_doc) do
    block_element.repeat(1)
  end

  rule(:block_element) do
    list |
    definition_list |
    table |
    simple_block_elements |
    notextile_block_tags |
    extended_notextile_block |
    notextile_block |
    extended_blockquote |
    blockquote |
    blockcode |
    footnote |
    link_alias |
    pre_tag_block |
    extended_pre_block |
    pre_block |
    block_html |
    block_html_tag |
    self_closing_block_elements |
    section_break |
    undecorated_paragraph
  end

  rule(:self_closing_block_elements) do
    [:hr, :br].map {|type| (str(type) >> attributes?.as(:attributes) >> str(".") >> spaces >> block_end).as(type) }.reduce(:|)
  end

  SIMPLE_BLOCK_ELEMENTS = [:div, :p] +
    1.upto(6).map {|n| :"h#{n}" } # Heading levels 1-6

  rule(:simple_block_elements) do
    SIMPLE_BLOCK_ELEMENTS.map do |block_type|
      [send(block_type), send("extended_#{block_type}s")]
    end.flatten.reduce(:|)
  end

  SIMPLE_BLOCK_ELEMENTS.each do |block_type|
    rule("extended_#{block_type}s") { (((str(block_type.to_s) >> attributes?.as(:attributes) >> str(".. ") >> content.as(:content) >> block_end).as(block_type)).as(:first) >> ((extended_block_end.absent? >> undecorated_block.as(block_type)).repeat(1)).as(:successive) >> extended_block_end).as(:extended) }
    rule(block_type) { (str(block_type.to_s) >> attributes?.as(:attributes) >> str(". ") >> content.as(:content) >> block_end).as(block_type) }
  end

  rule(:footnote) do
    (str("fn") >> (match("[0-9]").repeat(1).as(:number) >> attributes?).as(:attributes) >> str(". ") >> content.as(:content) >> block_end).as(:footnote)
  end

  rule(:link_alias) do
    (str("[") >> match["a-zA-Z_-"].repeat(1).as(:alias) >> str("]") >> link_uri.as(:href) >> block_end).as(:link_alias)
  end
  rule(:link_uri) { RedClothParslet::Parser::Attributes::LinkUri.new }

  rule(:notextile_block_tags) { (str("<notextile>\n") >> (notextile_block_end_tag.absent? >> any).repeat.as(:s) >> notextile_block_end_tag >> block_end).as(:notextile) }
  rule(:notextile_block_end_tag) { str("\n</notextile>") }

  rule(:notextile_block) { (str("notextile. ") >> (block_end.absent? >> any).repeat.as(:s) >> block_end).as(:notextile) }
  rule(:extended_notextile_block) { (str("notextile.. ") >> ((str("\n") >> extended_block_end).absent? >> any).repeat.as(:s) >> extended_block_end).as(:notextile) }

  rule(:pre_block) { (str("pre. ") >> (block_end.absent? >> any).repeat.as(:s) >> block_end).as(:pre) }
  rule(:extended_pre_block) { (str("pre.. ") >> ((str("\n") >> extended_block_end).absent? >> any).repeat.as(:s) >> extended_block_end).as(:pre) }
  rule(:pre_tag_block) { RedClothParslet::Parser::PreTag.new >> (str("\n").repeat(1) | eof) }

  rule(:blockquote) { (str("bq") >> attributes?.as(:attributes) >> str(". ") >> (undecorated_paragraph).as(:content)).as(:bq) }
  rule(:extended_blockquote) { (str("bq") >> attributes?.as(:attributes) >> str(".. ") >> (undecorated_paragraph.repeat(1)).as(:content) >> extended_block_end).as(:bq) }

  rule(:blockcode) { (str("bc. ") >> (block_end.absent? >> any).repeat.as(:s) >> block_end).as(:bc) }
  rule(:extended_blockcode) { (str("bc.. ") >> ((str("\n") >> extended_block_end).absent? >> any).repeat.as(:s) >> extended_block_end).as(:bc) }

  rule(:section_break) { (str("*").repeat(3) | str("-").repeat(3) | str("_").repeat(3)).as(:section_break) >> block_end }

  rule(:undecorated_block) { content.as(:content) >> block_end }
  rule(:undecorated_paragraph) { unfinished_quote_paragraph | undecorated_block.as(:p) }
  rule(:unfinished_quote_paragraph) { (str('"').present? >> undecorated_block).as(:p_open_quote) }

  rule(:content) { RedClothParslet::Parser::Inline.new }
  rule(:block_html) { RedClothParslet::Parser::BlockHtmlElement.new }
  rule(:block_html_tag) { RedClothParslet::Parser::BlockHtmlTag.new >> (str("\n").repeat(1) | eof) }

  rule(:attributes?) { RedClothParslet::Parser::Attributes.new.attribute.repeat }

  rule(:eof) { str("\n").repeat >> any.absent? }
  rule(:basic_block_end) { eof | double_newline }
  rule(:block_end) { basic_block_end | immediate_li }
  rule(:extended_block_end) { (eof | next_block_start | immediate_li).present? }
  rule(:next_block_start) { match("[a-z]").repeat(1) >> attributes? >> (str('. ') | str('.. ')) }
  rule(:double_newline) { str("\n") >> (match("[\s\t]").repeat >> str("\n")).repeat(1) }
  rule(:spaces) { match("[\t ]").repeat }
  rule(:immediate_li) { str("\n") >> (li_start | dt).present? }
end

require 'redcloth-parslet/parser/block/lists'
require 'redcloth-parslet/parser/block/tables'
