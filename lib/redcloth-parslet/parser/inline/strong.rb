module RedClothParslet::Parser
  module Strong
    include Parslet
    
    rule(:strong) { (str('*').as(:inline) >> inline_inside_strong.as(:content) >> end_strong) }
    rule(:end_strong) { str('*') >> match("[a-zA-Z0-9]").absent? }
    
    rule :inline_inside_strong do
      inline_sp.absent? >>
      (
        inline_sp.as(:s) >> term_inside_strong.present? |
        (inline_sp >> str('*')).as(:s) >> inline_sp.present? |
        term_inside_strong
      ).repeat(1)
    end
    
    rule :term_inside_strong do
      em |
      word_inside_strong.as(:s)
    end
    # 
    # rule :plain_phrase_inside_strong do
    #   (
    #     word_inside_strong >> 
    #     (inline_sp >> subsequent_word_inside_strong).repeat
    #   ).as(:s)
    # end

    rule :word_inside_strong do
      char = (end_strong.absent? >> mchar)
      char.repeat(1)
    end
    
  end
end