describe RedClothParslet::Parser::Block do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  context "undecorated paragraph" do
    it { should parse("Just plain text.").with(transform).
      as([RedClothParslet::Ast::P.new(["Just plain text."])]) }
  end

  context "explicit paragraph" do
    it { should parse("p. This is a paragraph.").with(transform).
      as([RedClothParslet::Ast::P.new(["This is a paragraph."])]) }
  end
  
end
