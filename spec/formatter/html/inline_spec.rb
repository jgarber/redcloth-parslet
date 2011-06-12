describe RedClothParslet::Formatter::HTML do
  subject { described_class.new().convert(element) }

  describe "strong" do
    let(:element) { RedClothParslet::Ast::Strong.new(["inside"]) }
    it { should == "<strong>inside</strong>" }
  end

  describe "em" do
    let(:element) { RedClothParslet::Ast::Em.new("inside") }
    it { should == "<em>inside</em>" }
  end
  
  describe "b" do
    let(:element) { RedClothParslet::Ast::B.new(["inside"]) }
    it { should == "<b>inside</b>" }
  end

  describe "i" do
    let(:element) { RedClothParslet::Ast::I.new("inside") }
    it { should == "<i>inside</i>" }
  end
  
  describe "em inside strong" do
    let(:element) { RedClothParslet::Ast::Strong.new(RedClothParslet::Ast::Em.new("inside")) }
    it { should == "<strong><em>inside</em></strong>" }
  end

end
