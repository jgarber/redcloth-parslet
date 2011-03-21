class RedClothParslet::Parser::Inline < Parslet::Parser
  
  rule(:inline) do
    inline_element.repeat(1)
  end
  
  # Inline elements are terms (words) divided by spaces. The term's
  # trailing spaces (if any) are captured by the term.
  rule(:inline_element) do
    term |
    plain_phrase
  end
  
  def inline_except(char_exception = nil)
    (term | plain_phrase(char_exception)).repeat(1)
  end
  
  rule(:term) do
    strong.as(:strong)
  end
  
  rule(:strong) { (str('*') >> inline_except(end_strong).as(:content) >> end_strong) >> inline_sp?.as(:tr_sp) }
  rule(:end_strong) { str('*') >> match("[a-zA-Z0-9]").absent? }

  def plain_phrase(char_exception = nil)
    (word(char_exception) >> (inline_sp >> term.absent? >> word(char_exception)).repeat >> inline_sp?).as(:s)
  end
  
  def word(char_exception = nil)
    char = char_exception.nil? ? mchar : (char_exception.absent? >> mchar)
    char.repeat(1)
  end
  
  # rule(:plain_phrase) { (word >> (inline_sp >> plain_word).repeat >> inline_sp?).as(:s) }
  # rule(:plain_word) { strong.absent? >> word }
  # rule(:word) {
  #   ((end_strong.absent? >> mchar).repeat(1) |
  #   str("*"))
  # }
  rule(:mchar) { match('\S') }
  rule(:inline_sp?) { inline_sp.repeat }
  rule(:inline_sp) { match('[ \t]').repeat(1) }
  # rule(:punct) { match('[?.!]') }
  # rule(:punct?) { punct.repeat }
  
  root(:inline)
end