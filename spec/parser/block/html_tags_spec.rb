describe RedClothParslet::Parser::Block do
  let(:transform) { RedClothParslet::Transform.new }

  describe "HTML tags" do
    describe "div" do
      context "with line breaks" do
        it { should parse("<div>\nSomething inside.\n\n</div>").with(transform).
             as([
               html_tag("<div>"),
               p("Something inside."),
               html_tag("</div>") ]) }
      end

      context "without line breaks" do
        it { should parse("<div>Something inside.</div>").with(transform).
             as([
               html_element("Something inside.", :open_tag => "<div>", :close_tag => "</div>")
        ]) }
      end
    end

    describe "pre" do
      it { should parse("<pre>\nThe bold tag is <b>\n</pre>").with(transform).
           as(pre("\nThe bold tag is <b>\n", :open_tag => '<pre>')) }
      it { should parse("<pre>No breaks</pre>").with(transform).
           as(pre("No breaks", :open_tag => "<pre>")) }
    end

    describe "pre + code" do
      it { should parse("<pre><code>\nThe bold tag is <b>\n</code></pre>").with(transform).
           as(pre(code("\nThe bold tag is <b>\n", :open_tag => '<code>'), :open_tag => '<pre>')) }
      it { should parse("<pre>\n<code>\nNo breaks</code>\n</pre>").with(transform).
           as(pre(["\n", code("\nNo breaks", :open_tag => '<code>'), "\n"], :open_tag => "<pre>")) }
    end

    describe "unknown tag is a block tag by default" do
      it { should parse(%Q{<abc def="a=1&b=2">}).with(transform).
           as(html_tag(%Q{<abc def="a=1&b=2">})) }
    end

    describe "unclosed html tags" do
      it { should parse("<notextile>\n# *test*").with(transform).
           as([ p(html_tag("<notextile>")), ol([li([strong("test")])]) ]) }
      it { should parse("<script>\nfunction main(){}").with(transform).
           as(html_element("function main(){}", :open_tag => '<script>', :close_tag => '')) }
    end
  end
end
