module RedClothParslet::Ast
  class P < Element; end
  class Notextile < Element; end
  class Pre < Element; end
  class HtmlTag < Element; end
  class HtmlElement < Element; end
  class EscapedHtml < Element; end
  class H1 < Element; end
  class H2 < Element; end
  class H3 < Element; end
  class H4 < Element; end
  class H5 < Element; end
  class H6 < Element; end
  class Div < Element; end
  class Ul < Element; end
  class Ol < Element; end
  class Li < Element; end
  class Dl < Element; end
  class Dt < Element; end
  class Dd < Element; end
  class Hr < Element; end
  class Br < Element; end

  class Blockquote < Element; end
  class Blockcode < Element; end

  class Table < Element; end
  class TableRow < Element; end
  class TableData < Element; end
  class TableHeader < Element; end

  class Footnote < Element; end

  class List
    @@last_list_count = 0
    def self.build(li_hashes, opts={})
      list_nesting = []
      list_layout = ""

      li_hashes.each do |li|
        if li[:layout] == list_layout
        elsif li[:layout].size < list_layout.size
          closed_list = list_nesting.pop
          list_nesting.last.children << closed_list
        else
          list_nesting << ((li[:layout].to_s[-1,1] == "*") ? Ul.new : Ol.new)
          if cont = li[:continuation]
            opts[:start] = cont == '_' ? @@last_list_count + 1 : cont.to_i
          end
          if opts.any?
            list_nesting.last.opts = opts
            opts = {}
          end
        end
        list_layout = li[:layout]
        list_nesting.last.children << Li.new(li[:content], li[:opts])
      end
      until list_nesting.size == 1 do
        closed_list = list_nesting.pop
        list_nesting.last.children << closed_list
      end
      list_start_number = list_nesting.first.opts[:start] || 1
      @@last_list_count = list_start_number + list_nesting.first.children.size - 1
      list_nesting.first
    end
  end

end
