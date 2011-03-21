class RedClothParslet::Parser::Inline < Parslet::Parser
  
  rule(:inline) do
    inline_element.repeat(1)
  end
  
  # Inline elements are "words" divided by spaces. They capture any
  # trailing spaces as well.
  rule(:inline_element) do
    strong.as(:strong) |
    word
  end
  
  def inline_except(exception)
    (strong | word_except(exception)).repeat(1)
  end
  
  rule(:strong) { (str('*') >> inline_except(end_strong).as(:content) >> end_strong) >> inline_sp?.as(:tr_sp) }
  rule(:end_strong) { str('*') >> match("[a-zA-Z0-9]").absent? }
  
  
  def word_except(exception)
    ((exception.absent? >> mchar >> inline_sp?).repeat(1)).as(:s)
  end
  
  def word
    ((mchar).repeat(1) >> inline_sp?).as(:s)
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