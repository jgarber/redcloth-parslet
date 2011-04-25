class RedClothParslet::Parser::Attributes < Parslet::Parser
  root(:attributes)
  rule(:attributes) do
    attribute.repeat(1)
  end
  
  rule(:attribute) do
    class_id |
    style
  end
  
  rule(:class_id) do
    str('(') >> (
      classes >> id |
      classes |
      id
    ) >> str(')')
  end
  
  rule(:classes) do
    (class_id_char | class_id_sp).repeat(1).as(:class)
  end
  rule(:class_id_char) { match('[^\s)#]') }
  
  rule(:id) do
    str('#') >> class_id_char.repeat(1).as(:id)
  end
  
  rule(:style) do
    str('{') >> (str('}').absent? >> mchar).repeat(1).as(:style) >> str('}')
  end
  
  # TODO: extract this out into a base parser and inherit to keep it DRY
  rule(:mchar) { match('\S') }
  rule(:class_id_sp) { match('[ \t]') }
end
