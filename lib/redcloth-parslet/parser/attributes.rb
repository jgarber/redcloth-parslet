class RedClothParslet::Parser::Attributes < Parslet::Parser
  root(:attributes)
  rule(:attributes) do
    attribute.repeat(1)
  end
  
  rule(:attribute) do
    class_id |
    style |
    align |
    padding
  end
  
  rule(:class_id) do
    str('(') >> (
      classes >> id |
      classes |
      id
    ) >> str(')')
  end
  rule(:classes) { (class_id_char | class_id_sp).repeat(1).as(:class) }
  rule(:id) { str('#') >> class_id_char.repeat(1).as(:id) }
  rule(:class_id_char) { match('[^\s<>()#]') }
  
  rule(:style) do
    str('{') >> (str('}').absent? >> mchar).repeat(1).as(:style) >> str('}')
  end
  
  rule(:align) { match('[<>=]').as(:align) }
  rule(:padding) { match('[()]').as(:padding) }
  
  # TODO: extract this out into a base parser and inherit to keep it DRY
  rule(:mchar) { match('\S') }
  rule(:class_id_sp) { match('[ \t]') }
end

require 'redcloth-parslet/parser/attributes/uri'
require 'redcloth-parslet/parser/attributes/nongreedy_uri'
