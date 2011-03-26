require 'redcloth-parslet/parser/inline/strong'
require 'redcloth-parslet/parser/inline/em'

class RedClothParslet::Parser::Inline < Parslet::Parser
  include RedClothParslet::Parser::Strong
  include RedClothParslet::Parser::Em
  
  root(:inline)
  rule(:inline) do
    inline_sp.absent? >>
    inline_element.repeat(1)
  end
  
  # Inline elements are terms (words) divided by spaces. The term's
  # trailing spaces (if any) are captured by the term.
  rule(:inline_element) do
    inline_sp.as(:s) >> term.present? |
    term
  end
  
  rule(:term) do
    strong |
    em |
    word.as(:s)
  end
  
  # def plain_phrase
  #   (
  #     word >> 
  #     (inline_sp >> term.absent? >> word).repeat
  #   ).as(:s)
  # end
  
  rule :word do
    mchar.repeat(1)
  end
  
  # def safe_trailing_space
  #   match('[ \t]')
  # end

  rule(:mchar) { match('\S') }
  rule(:inline_sp?) { inline_sp.repeat }
  rule(:inline_sp) { match('[ \t]').repeat(1) }
end