describe RedClothParslet::Formatter::HTML do
  subject { described_class.new(:order_attributes => true).convert(element) }

  %w(strong em span b i ins del).each do |tag|
    describe tag do
      let(:element) { RedClothParslet::Ast.const_get(tag.capitalize).new(["inside"], {:class => 'myclass'}) }
      it { should == "<#{tag} class=\"myclass\">inside</#{tag}>" }
    end
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
    {"--"=>"&#8212;", " -"=>" &#8211;", "..."=>"&#8230;", "x"=>"&#215;"}.each do |input,output|
      it "should escape #{input} as #{output}" do
        described_class.new().convert(RedClothParslet::Ast::Entity.new(input)).should == output
      end
    end
  end
  
  describe "dimension" do
    context "feet" do
      let(:element) { RedClothParslet::Ast::Dimension.new("500'") }
      it { should == "500&#8242;" }
    end
    context "inches" do
      let(:element) { RedClothParslet::Ast::Dimension.new('2 1/2"') }
      it { should == "2 1/2&#8243;" }
    end
  end
  
  describe "link" do
    let(:element) { RedClothParslet::Ast::Link.new(["Google"], {:href=>"http://google.com"}) }
    it { should == '<a href="http://google.com">Google</a>' }
  end
  
  describe "image" do
    let(:element) { RedClothParslet::Ast::Img.new([], {:src=>"mac.png"}) }
    it { should == '<img alt="" src="mac.png" />' }
  end
  
  describe "image with alt" do
    let(:element) { RedClothParslet::Ast::Img.new([], {:src=>"mac.png", :alt=>"Mac"}) }
    it "should also populate title" do
      subject.should == '<img alt="Mac" src="mac.png" title="Mac" />'
    end
  end
  
  describe "image with alignment" do
    let(:element) { RedClothParslet::Ast::Img.new([], {:src=>"mac.png", :align=>"left"}) }
    it { should == '<img align="left" alt="" src="mac.png" />' }
  end
  
  describe "acronym" do
    let(:element) { RedClothParslet::Ast::Acronym.new("CSS", {:title => "Cascading Style Sheets"}) }
    it { should == '<acronym title="Cascading Style Sheets">CSS</acronym>' }
  end

  describe "caps" do
    let(:element) { RedClothParslet::Ast::Caps.new("CSS") }
    it { should == '<span class="caps">CSS</span>' }
  end

  describe "code" do
    let(:element) { RedClothParslet::Ast::Code.new("puts 'hello world'") }
    it { should == "<code>puts &#39;hello world&#39;</code>" }
  end
end
