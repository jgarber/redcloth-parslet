describe RedClothParslet::Parser::Block do
  let(:transform) { RedClothParslet::Transform.new }

  describe "HTML tags" do
    describe "div" do
      it { should parse("<div>\nSomething inside.\n\n</div>").with(transform).
        as([
          RedClothParslet::Ast::HtmlTag.new("<div>"),
          RedClothParslet::Ast::P.new("Something inside."),
          RedClothParslet::Ast::HtmlTag.new("</div>")
        ]) }
    end
    
    describe "pre" do
      it { should parse("<pre>\nThe bold tag is <b>\n</pre>").with(transform).
        as([RedClothParslet::Ast::Pre.new("\nThe bold tag is <b>\n", :open_tag => '<pre>')]) }
      it { should parse("<pre>No breaks</pre>").with(transform).
        as([RedClothParslet::Ast::Pre.new("No breaks", :open_tag => "<pre>")]) }
    end

    describe "pre + code" do
      it { should parse("<pre><code>\nThe bold tag is <b>\n</code></pre>").with(transform).
        as([RedClothParslet::Ast::Pre.new(RedClothParslet::Ast::Code.new("\nThe bold tag is <b>\n", :open_tag => '<code>'), :open_tag => '<pre>')]) }
      it { should parse("<pre>\n<code>\nNo breaks</code>\n</pre>").with(transform).
        as([RedClothParslet::Ast::Pre.new(["\n", RedClothParslet::Ast::Code.new("\nNo breaks", :open_tag => '<code>'), "\n"], :open_tag => "<pre>")]) }
    end
  end
end
