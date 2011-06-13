describe RedClothParslet::Parser::Block do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "ul" do
    it { should parse("* one\n* two").with(transform).
      as([RedClothParslet::Ast::Ul.new([
        RedClothParslet::Ast::Li.new(["one"]), 
        RedClothParslet::Ast::Li.new(["two"])
      ])]) }

    it { should parse("* 1\n** 1.1").with(transform).
      as([
        RedClothParslet::Ast::Ul.new([
          RedClothParslet::Ast::Li.new(["1"]), 
          RedClothParslet::Ast::Ul.new(RedClothParslet::Ast::Li.new(["1.1"]))
        ])
      ]) }
  end
  
end