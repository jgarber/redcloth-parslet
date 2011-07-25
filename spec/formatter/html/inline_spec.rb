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
  
  describe "double-quoted phrase" do
    let(:element) { RedClothParslet::Ast::DoubleQuotedPhrase.new("Hello") }
    it { should == "&#8220;Hello&#8221;" }
  end
  
  describe "entities" do
    {"--"=>"&#8212;"}.each do |input,output|
      it "should escape #{input} as #{output}" do
        described_class.new().convert(RedClothParslet::Ast::Entity.new(input)).should == output
      end
    end
  end
  
  describe "link" do
    let(:element) { RedClothParslet::Ast::Link.new(["Google"], {:href=>"http://google.com"}) }
    it { should == '<a href="http://google.com">Google</a>' }
  end
  
  describe "image" do
    let(:element) { RedClothParslet::Ast::Img.new([], {:src=>"mac.png"}) }
    it { should == '<img src="mac.png" alt="" />' }
  end
  
  describe "image with alt" do
    let(:element) { RedClothParslet::Ast::Img.new([], {:src=>"mac.png", :alt=>"Mac"}) }
    it "should also populate title" do
      subject.should == '<img src="mac.png" title="Mac" alt="Mac" />'
    end
  end
  
  describe "image with alignment" do
    let(:element) { RedClothParslet::Ast::Img.new([], {:src=>"mac.png", :align=>"left"}) }
    it { should == '<img src="mac.png" align="left" alt="" />' }
  end
  
  describe "acronym" do
    let(:element) { RedClothParslet::Ast::Acronym.new("CSS", {:title => "Cascading Style Sheets"}) }
    it { should == '<acronym title="Cascading Style Sheets">CSS</acronym>' }
  end
end
