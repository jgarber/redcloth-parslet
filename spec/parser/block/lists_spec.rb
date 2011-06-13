describe RedClothParslet::Parser::Block do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "ul" do
    
    it { should parse("* one\n* two").with(transform).
      as([RedClothParslet::Ast::Ul.new([
        RedClothParslet::Ast::Li.new(["one"]), 
        RedClothParslet::Ast::Li.new(["two"])
      ])]) }
    
  end
  
end