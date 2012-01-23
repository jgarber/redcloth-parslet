module RedClothParslet::Ast
  class P < Element; end
  class Notextile < Element; end
  class HtmlTag < Element; end
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

  class Blockquote < Element; end

  class Table < Element; end
  class TableRow < Element; end
  class TableData < Element; end
  class TableHeader < Element; end

  class List
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
      list_nesting.first
    end
  end

end