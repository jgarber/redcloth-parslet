module RedClothParslet::Parser
  class HtmlTag < Parslet::Parser
    root(:tag)
    rule(:tag) do
      (
        open_tag |
        close_tag |
        self_closing_tag
      ).as(:html_tag)
    end

    rule(:self_closing_tag) { str("<") >> tag_name >> attributes? >> (spaces? >> str("/")) >> str(">") }
    rule(:open_tag) { str("<") >> tag_name >> attributes? >> str(">") }
    rule(:close_tag) { str("</") >> tag_name >> str(">") }

    rule(:tag_name) do
      match("[A-Za-z_:]") >> name_char.repeat
    end

    rule(:attributes?) do
      attribute.repeat
    end

    rule(:attribute) do
      spaces >> attribute_name >> (str("=") >> attribute_value).maybe
    end
    rule(:attribute_name) { match("[A-Za-z_:]") >> name_char.repeat(1) }
    rule(:attribute_value) { (str('"') >> match('[^"]').repeat >> str('"') | str("'") >> match("[^']").repeat >> str("'") ) }

    rule(:name_char) { match("[\-A-Za-z0-9._:?]") }
    rule(:space) { match("[ \t]") }
    rule(:spaces) { space.repeat(1) }
    rule(:spaces?) { space.repeat }
  end
  
  class BlockHtmlTag < HtmlTag
    rule(:tag_name) do
      inline_tag_name.absent? >> match("[A-Za-z_:]") >> name_char.repeat #FIXME: how can we integrate `super`?
    end
    
    rule(:inline_tag_name) do
      %w(pre notextile a applet basefont bdo br font iframe img map object param embed q script span sub sup abbr acronym cite code del dfn em ins kbd samp strong var b big i s small strike tt u).map {|name| str(name) }.reduce(:|)
    end
  end
end
