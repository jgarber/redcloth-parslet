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
    
    context "attributes" do
      it { should parse("p(myclass). This is a paragraph.").with(transform).
        as([RedClothParslet::Ast::P.new(["This is a paragraph."], {:class=>'myclass'})]) }
    end
  end
  
  context "successive paragraphs" do
    it { should parse("One paragraph.\n\nTwo.").with(transform).
      as([RedClothParslet::Ast::P.new(["One paragraph."]), RedClothParslet::Ast::P.new(["Two."])]) }
    
    it { should parse("p. Double.\n\np. Trouble.").with(transform).
      as([RedClothParslet::Ast::P.new(["Double."]), RedClothParslet::Ast::P.new(["Trouble."])]) }
      
    it { should parse("Mix it up.\n\np. Just a bit.\n\nNo worries, mate.").with(transform).
      as([RedClothParslet::Ast::P.new(["Mix it up."]), 
          RedClothParslet::Ast::P.new(["Just a bit."]),
          RedClothParslet::Ast::P.new(["No worries, mate."])]) }
  end
  
  context "notextile block" do
    it { should parse("<notextile>\nsomething\n</notextile>").with(transform).
      as([RedClothParslet::Ast::Notextile.new(["something"])]) }
    it { should parse("notextile. something").with(transform).
      as([RedClothParslet::Ast::Notextile.new(["something"])]) }
  end
  
end
