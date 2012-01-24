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
  end
end
