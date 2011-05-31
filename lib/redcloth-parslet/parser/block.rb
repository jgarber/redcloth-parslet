class RedClothParslet::Parser::Block < Parslet::Parser
  root(:textile_doc)
  rule(:textile_doc) do
    block_element.repeat(1)
  end
  
  rule(:block_element) do
    paragraph
  end
  
  rule(:paragraph) { (explicit_paragraph | undecorated_paragraph).as(:p) }
  rule(:explicit_paragraph) { str("p") >> attributes?.as(:attributes) >> str(". ") >> content.as(:content) >> block_end }
  rule(:undecorated_paragraph) { content.as(:content) >> block_end }
  
  rule(:content) { RedClothParslet::Parser::Inline.new }
  
  rule(:attributes?) { RedClothParslet::Parser::Attributes.new.attribute.repeat }
  
  rule(:eof) { any.absent? }
  rule(:block_end) { eof | str("\n\n") }
end