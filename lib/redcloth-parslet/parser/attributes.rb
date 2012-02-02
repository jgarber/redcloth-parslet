class RedClothParslet::Parser::Attributes < Parslet::Parser
  root(:attributes)
  rule(:attributes) do
    attribute.repeat(1)
  end
  
  rule(:attribute) do
    class_id |
    lang |
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
  rule(:class_id_char) { match('[^\]\[\s<>()#]') }
  rule(:lang) { str("[") >> class_id_char.repeat(1).as(:lang) >> str("]") }
  
  rule(:style) do
    str('{') >> (str('}').absent? >> (str(" ") | mchar)).repeat(1).as(:style) >> str('}')
  end
  
  rule(:align) { match('[<>=]').as(:align) }
  rule(:padding) { match('[()]').as(:padding) }
  
  rule(:table_attributes) do
    table_attribute.repeat(1)
  end
  rule(:table_attribute) do
    colspan |
    rowspan |
    attribute
  end
  rule(:colspan) { str('\\') >> digits.as(:colspan) }
  rule(:rowspan) { str('/') >> digits.as(:rowspan) }
  rule(:digits) { match("[0-9]").repeat(1) }

  # TODO: extract this out into a base parser and inherit to keep it DRY
  rule(:mchar) { match('\S') }
  rule(:class_id_sp) { match('[ \t]') }
end

require 'redcloth-parslet/parser/attributes/uri'
require 'redcloth-parslet/parser/attributes/nongreedy_uri'
