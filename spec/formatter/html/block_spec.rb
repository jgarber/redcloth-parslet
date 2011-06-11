describe RedClothParslet::Formatter::HTML do
  subject { described_class.new().convert(element) }
  
  describe "line breaks" do
    let(:element) { RedClothParslet::Ast::P.new(["Line one\nline two."]) }
    it { should == "<p>Line one<br />line two.</p>" }
  end

  
  describe "p" do
    let(:element) { RedClothParslet::Ast::P.new(["My paragraph."]) }
    it { should == "<p>My paragraph.</p>" }
  end

  describe "notextile" do
    let(:element) { RedClothParslet::Ast::Notextile.new(["inside"]) }
    it { should == "inside" }
  end
end
