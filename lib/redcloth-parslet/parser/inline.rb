class RedClothParslet::Parser::Inline < Parslet::Parser
  include RedClothParslet::Parser::Common

  root(:inline)
  rule(:inline) do
    sp.absent? >>
    inline_element.repeat(1)
  end

  SIMPLE_INLINE_ELEMENTS = [
    [:b, '**'],
    [:i, '__'],
    [:strong, '*'],
    [:em, '_'],
    [:span, '%'],
    [:ins, '+'],
    [:del, '-'],
    [:code, '@'],
    [:sup, '^'],
    [:sub, '~'],
    [:cite, '??']
  ]
  
  # Inline elements include spaces and terms/words divided by spaces.
  # Sometimes terms are contiguous, such as <code>*bold*.</code> (bold phrase 
  # followed by a period, which is a word).
  rule(:inline_element) do
    notextile_tags |
    notextile_double_equals |
    standalone_en_dash |
    standalone_symbol_from_simple_inline_element |
    space_between_terms |
    term
  end

  rule(:space_between_terms) do
    sp.as(:s) >> term.present?
  end
  
  rule(:list_contents) do
    inline.exclude(:li_start)
  end
  
  rule(:table_contents) do
    (inline_element.exclude(:table_cell_start) | inline_sp.as(:s)).repeat(1)
  end
  
  rule(:sovereign_term) do
    exclude_end_rules >>
    ( typographic_entity |
      html_entity |
      image |
      link.unless_excluded(:link) |
      double_quoted_phrase.unless_excluded(:double_quoted_phrase) |
      simple_inline_term |
      parenthesized_sovereign_term |
      acronym |
      all_caps_word |
      dimensions |
      html_tag )
  end

  rule(:forced_inline_term) do
    (str("[") >> double_quoted_phrase >> str("]")).as(:forced_quote) |
    forced_simple_inline_term |
    str("[") >> sovereign_term >> str("]")
  end

  rule(:term) do
    code_tag |
    sovereign_term |
    forced_inline_term |
    word
  end
  
  rule(:simple_inline_term) do
    SIMPLE_INLINE_ELEMENTS.map {|el,mark| send(el).unless_excluded(el) }.reduce(:|)
  end

  rule(:simple_inline_term_end_exclusion) do
    SIMPLE_INLINE_ELEMENTS.map {|el,mark| send("end_#{el}").absent?.if_excluded(el) }.reduce(:>>)
  end

  # general pattern for inline elements
  SIMPLE_INLINE_ELEMENTS.each do |element_name, signature|
    end_rule_name = "end_#{element_name}".to_sym
    rule(element_name) do
      (str(signature) >>
      maybe_preceded_by_attributes(inline.exclude(element_name).exclude(:newline).as(:content)) >> 
      send(end_rule_name)).as(element_name)
    end
    rule(end_rule_name) { str(signature) >> match("[a-zA-Z0-9]").absent? }
  end
  # exceptions to above pattern
  rule(:end_strong) { str('*') >> match("[a-zA-Z0-9*]").absent? }
  rule(:end_em) { str('_') >> match("[a-zA-Z0-9_]").absent? }
  rule(:end_cite) { str('??') >> match("[a-zA-Z0-9?]").absent? }

  rule(:forced_simple_inline_term) do
    SIMPLE_INLINE_ELEMENTS.map {|el,mark| send("forced_#{el}").unless_excluded(el) }.reduce(:|)
  end
  SIMPLE_INLINE_ELEMENTS.each do |element_name, signature|
    rule_name = "forced_#{element_name}"
    end_rule_name = "end_#{rule_name}"
    rule(rule_name) do
      (str("[") >> str(signature) >>
      maybe_preceded_by_attributes((
        (send(end_rule_name).absent? >> any).repeat(1).as(:s)
      ).as(:content)) >>
      send(end_rule_name)).as(element_name)
    end
    rule(end_rule_name) { str(signature) >> str("]") }
  end

  rule(:parenthesized_sovereign_term) { (str('(') >> sovereign_term.as(:content) >> str(')')).as(:parentheses) }
  
  rule(:acronym) do
    (
      match("[A-Z]").as(:s).repeat(1).as(:content) >> 
      (str('(') >>  
        (str(')').absent? >> any).repeat(1).as(:title) >> 
        str(')')
      ).as(:attributes)
    ).as(:acronym)
  end

  rule(:all_caps_word) do
    match("[A-Z]").repeat(3).as(:caps) >>
      (match('[a-z0-9]').repeat(1) >> match('[A-Z]')).absent?
  end

  rule :word do
    char = (exclude_significant_end_characters >> mchar)
    char.repeat(1).as(:s) >> footnote_reference.maybe
  end
  rule :exclude_significant_end_characters do
    html_tag.absent? >>
    forced_inline_term.absent? >>
    footnote_reference.absent? >>
    # TODO: make this the same rule as in parser/block/lists.rb so it's DRY.
    (match("[*#]").repeat(1) >> str(" ")).absent?.if_excluded(:li_start) >>
    # TODO: make this the same rule as in parser/block/tables.rb so it's DRY.
    str("|").absent?.if_excluded(:table_cell_start) >>
    str(')').absent?.if_excluded(:paren) >>
    (str('"') | end_link).absent?.if_excluded(:link) >>
    end_double_quoted_phrase.absent?.if_excluded(:double_quoted_phrase) >>
    simple_inline_term_end_exclusion
  end
  rule :exclude_end_rules do
    end_link.absent?.if_excluded(:link)
  end

  rule :footnote_reference do
    str("[") >> digits.as(:footnote_reference) >> str("]")
  end

  rule(:notextile_tags) { (str("<notextile>") >> (notextile_end_tag.absent? >> any).repeat.as(:s) >> notextile_end_tag).as(:notextile) }
  rule(:notextile_end_tag) { str("</notextile>") }
  rule(:notextile_double_equals) { (str("==") >> (notextile_double_equals_end.absent? >> any).repeat.as(:s) >> notextile_double_equals_end).as(:notextile) }
  rule(:notextile_double_equals_end) { str("==") }

  rule(:mchar) { typographic_entity.absent? >> match('\S') }
  rule(:inline_sp) { match('[ \t]').repeat(1) }
  rule(:inline_sp?) { inline_sp.maybe }
  rule(:sp) { inline_sp | str("\n").unless_excluded(:newline) }

  rule(:html_tag) { RedClothParslet::Parser::HtmlTag.new }

  def maybe_preceded_by_attributes(content_rule)
    attributes?.as(:attributes) >> inline_sp.maybe >> content_rule |
    content_rule
  end

  rule(:attribute) { RedClothParslet::Parser::Attributes.new.attribute }
  rule(:attributes?) { (exclude_significant_end_characters >> attribute).repeat }
end

require 'redcloth-parslet/parser/inline/code'
require 'redcloth-parslet/parser/inline/entities'
require 'redcloth-parslet/parser/inline/image'
require 'redcloth-parslet/parser/inline/link'
require 'redcloth-parslet/parser/inline/quotes'
