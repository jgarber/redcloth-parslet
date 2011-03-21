module RedClothParslet::Parser
  module Strong
    include Parslet
    
    rule(:strong) { (str('*').as(:inline) >> inline_inside_strong.as(:content) >> end_strong) }
    rule(:end_strong) { str('*') >> match("[a-zA-Z0-9]").absent? }
    
    def inline_inside_strong
      inline_sp.absent? >>
      (
        plain_phrase_inside_strong
      ).repeat(1)
    end

    def plain_phrase_inside_strong
      (
        inline_sp? >> 
        word_inside_strong >> 
        (inline_sp >> subsequent_word_inside_strong).repeat
      ).as(:s)
    end

    def word_inside_strong
      char = (end_strong.absent? >> mchar)
      char.repeat(1)
    end
    def subsequent_word_inside_strong
      char = (end_strong.absent? >> mchar)
      mchar >> char.repeat
    end
    
  end
end