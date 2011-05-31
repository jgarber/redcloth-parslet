describe RedClothParslet::Formatter::HTML do
  subject { described_class.new().convert(element) }

  describe "p" do
    let(:element) { RedClothParslet::Ast::P.new(["My paragraph."]) }
    it { should == "<p>My paragraph.</p>" }
  end

end
