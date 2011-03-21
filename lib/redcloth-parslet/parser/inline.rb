class RedClothParslet::Parser::InlineParser < Parslet::Parser
  
  rule(:inline) do
    (inline_element >> (inline_spaces >> inline_element >> punct?).repeat)
  end
  
  rule(:inline_element) do
    strong |
    plain_phrase
  end
  
  rule(:strong) { (str('*') >> inline >> end_strong).as(:strong) }
  rule(:end_strong) { str('*') >> match("[a-zA-Z0-9]").absent? }
  
  rule(:plain_phrase) { (word >> (inline_spaces >> plain_word).repeat).as(:s) }
  rule(:plain_word) { strong.absent? >> word }
  rule(:word) {
    ((end_strong.absent? >> mchar).repeat(1) |
    str("*"))
  }
  rule(:mchar) { match('\S') }
  rule(:inline_spaces) { match('[ \t]').repeat(1) }
  rule(:punct) { match('[?.!]') }
  rule(:punct?) { punct.repeat }
  
  root(:inline)
end