describe RedClothParslet::Parser::Block do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  context "undecorated paragraphs" do
    it { should parse("Just plain text.").with(transform).
      as([RedClothParslet::Ast::P.new(["Just plain text."])]) }
  end

  context "explicit paragraphs" do
    it { should parse("p. This is a paragraph.").with(transform).
      as([RedClothParslet::Ast::P.new(["This is a paragraph."])]) }
  end
  
  context "successive paragraphs" do
    it { should parse("One paragraph.\n\nTwo.").with(transform).
      as([RedClothParslet::Ast::P.new(["One paragraph."]), RedClothParslet::Ast::P.new(["Two."])]) }
    
    it { should parse("p. Double.\n\np. Trouble.").with(transform).
      as([RedClothParslet::Ast::P.new(["Double."]), RedClothParslet::Ast::P.new(["Trouble."])]) }
  end
  
end
