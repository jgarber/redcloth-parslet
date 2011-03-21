class RedClothParslet::Parser::Inline < Parslet::Parser
  
  root(:inline)
  rule(:inline) do
    inline_except(nil)
  end
  
  # Inline elements are terms (words) divided by spaces. The term's
  # trailing spaces (if any) are captured by the term.
  
  def inline_except(char_exception = nil)
    inline_sp.absent? >> (term | plain_phrase(char_exception)).repeat(1)
  end
  
  rule(:term) do
    strong
  end
  
  rule(:strong) { (str('*').as(:inline) >> inline_except(end_strong).as(:content) >> end_strong) }
  rule(:end_strong) { str('*') >> match("[a-zA-Z0-9]").absent? }

  def plain_phrase(char_exception = nil)
    (
      inline_sp? >> 
      word(char_exception) >> 
      (inline_sp >> term.absent? >> word(char_exception)).repeat >> 
      safe_trailing_space(char_exception).repeat
    ).as(:s)
  end
  
  def word(char_exception = nil)
    char = char_exception.nil? ? mchar : (char_exception.absent? >> mchar)
    char.repeat(1)
  end
  
  def safe_trailing_space(char_exception = nil)
    char_exception.nil? ? match('[ \t]') : (match('[ \t]') >> char_exception.absent?)
  end

  rule(:mchar) { match('\S') }
  rule(:inline_sp?) { inline_sp.repeat }
  rule(:inline_sp) { match('[ \t]').repeat(1) }
end