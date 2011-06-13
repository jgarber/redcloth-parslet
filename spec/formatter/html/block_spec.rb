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

  describe "div" do
    let(:element) { RedClothParslet::Ast::Div.new(["I am a div"]) }
    it { should == "<div>I am a div</div>" }
  end
  
  describe "ul" do
    let(:element) { RedClothParslet::Ast::Ul.new([
      RedClothParslet::Ast::Li.new(["1"]), 
      RedClothParslet::Ast::Ul.new(RedClothParslet::Ast::Li.new(["1.1"])),
      RedClothParslet::Ast::Li.new(["2"])
    ]) }
    it { should == <<-END.gsub(/^ +/, '').chomp
      <ul>
      	<li>1
      	<ul>
      		<li>1.1</li>
      	</ul></li>
      	<li>2</li>
      </ul>
    END
    }
  end
end
