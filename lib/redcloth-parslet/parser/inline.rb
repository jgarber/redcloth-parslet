require 'redcloth-parslet/parser/inline/strong'

class RedClothParslet::Parser::Inline < Parslet::Parser
  include RedClothParslet::Parser::Strong
  
  root(:inline)
  rule(:inline) do
    inline_sp.absent? >>
    inline_element.repeat(1)
  end
  
  # Inline elements are terms (words) divided by spaces. The term's
  # trailing spaces (if any) are captured by the term.
  rule(:inline_element) do
    term | 
    plain_phrase
  end
  
  rule(:term) do
    strong
  end
  
  def plain_phrase
    (
      inline_sp? >> 
      word >> 
      (inline_sp >> term.absent? >> word).repeat >> 
      safe_trailing_space.repeat
    ).as(:s)
  end
  
  def word
    mchar.repeat(1)
  end
  
  def safe_trailing_space
    match('[ \t]')
  end

  rule(:mchar) { match('\S') }
  rule(:inline_sp?) { inline_sp.repeat }
  rule(:inline_sp) { match('[ \t]').repeat(1) }
end