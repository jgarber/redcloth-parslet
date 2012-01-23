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
  end
end
