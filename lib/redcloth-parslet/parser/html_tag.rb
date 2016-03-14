module RedClothParslet::Parser
  INLINE_TAGS = %w(a applet basefont bdo br font iframe img map object param embed q script span sub sup abbr acronym cite code del dfn em ins kbd samp strong var b big i s small strike tt u notextile)

  class HtmlTag < Parslet::Parser
    root(:tag)
    rule(:tag) do
      (
        open_tag |
        close_tag |
        self_closing_tag |
        comment_tag
      ).as(:html_tag)
    end

    rule(:self_closing_tag) { str("<") >> tag_name >> attributes? >> (spaces? >> str("/")) >> str(">") }
    rule(:open_tag) { str("<") >> tag_name >> attributes? >> str(">") }
    rule(:close_tag) { str("</") >> tag_name >> str(">") }

    rule(:comment_tag) do
      str("<!--") >>
      (comment_tag_end.absent? >> any).repeat >>
      comment_tag_end
    end
    rule(:comment_tag_end) { str("-->") }

    rule(:tag_name) { any_tag_name }
    rule(:any_tag_name) { match("[A-Za-z_:]") >> name_char.repeat }

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

    rule(:element) do
      open_tag.as(:open_tag) >>
      ((close_tag | RedClothParslet::Parser::Block.new.double_newline).absent? >> any.as(:s)).repeat.as(:content) >>
      close_tag.as(:close_tag)
    end
  end

  class BlockHtmlTag < HtmlTag
    rule(:tag_name) do
      ( inline_tag_name.absent? |
        (inline_tag_name >> name_char.repeat(1)).present?) >>
      any_tag_name
    end

    rule(:inline_tag_name) do
      INLINE_TAGS.map {|name| str(name) }.reduce(:|)
    end
  end

  class BlockHtmlElement < BlockHtmlTag
    root(:element)
  end

  class BrTag < HtmlTag
    rule(:tag_name) { str("br") }
    rule(:self_closing_tag) { str("<") >> tag_name >> attributes? >> (spaces? >> str("/")) >> str(">") >> spaces? >> str("\n").maybe }
    rule(:open_tag) { str("<") >> tag_name >> attributes? >> str(">") >> spaces? >> str("\n").maybe }
  end

  class CodeElement < HtmlTag
    root(:element)
    rule(:tag_name) { str("code") }
  end

  class PreTag < HtmlTag
    rule(:tag_name) { str("pre") }

    rule(:tag) do
      (open_tag.as(:open_tag) >>
      ((close_tag).absent? >> (CodeElement.new.as(:code_element) | any.as(:s))).repeat.as(:content) >>
      close_tag.as(:close_tag)).as(:pre_element)
    end
  end
end
