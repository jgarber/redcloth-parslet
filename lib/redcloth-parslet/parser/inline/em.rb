module RedClothParslet::Parser
  module Em
    include Parslet
    
    rule(:em) { leading_spaces? >> (str('_').as(:inline) >> inline_inside_em.as(:c) >> end_em) }
    rule(:end_em) { str('_') >> match("[a-zA-Z0-9]").absent? }
    
    def inline_inside_em
      inline_sp.absent? >>
      (
        strong |
        plain_phrase_inside_em
      ).repeat(1)
    end

    def plain_phrase_inside_em
      leading_spaces? >> 
      (
        inline_sp? >> 
        word_inside_em >> 
        (inline_sp >> strong.absent? >> subsequent_word_inside_em).repeat
      ).as(:s)
    end

    def word_inside_em
      char = (end_em.absent? >> mchar)
      char.repeat(1)
    end
    def subsequent_word_inside_em
      char = (end_em.absent? >> mchar)
      mchar >> char.repeat
    end
    
  end
end