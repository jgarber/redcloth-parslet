module RedClothParslet::Parser
  module Em
    include Parslet
    
    rule(:em) { (str('_').as(:inline) >> inline_inside_em.as(:content) >> end_em) }
    rule(:end_em) { str('_') >> match("[a-zA-Z0-9]").absent? }
    
    rule :inline_inside_em do
      inline_sp.absent? >>
      (
        inline_sp.as(:s) >> term_inside_em.present? |
        (inline_sp >> str('_')).as(:s) >> inline_sp.present? |
        term_inside_em
      ).repeat(1)
    end
    
    rule :term_inside_em do
      strong |
      word_inside_em.as(:s)
    end
    # 
    # rule :plain_phrase_inside_em do
    #   (
    #     word_inside_em >> 
    #     (inline_sp >> subsequent_word_inside_em).repeat
    #   ).as(:s)
    # end

    rule :word_inside_em do
      char = (end_em.absent? >> mchar)
      char.repeat(1)
    end
    
  end
end