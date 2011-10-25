describe RedClothParslet::Formatter::HTML do
  subject { described_class.new(:order_attributes => true).convert(element) }
  
  describe "class" do
    let(:element) { RedClothParslet::Ast::Strong.new("", :class=>'myclass') }
    it { should == %{<strong class="myclass"></strong>} }
  end
  
  describe "class + id" do
    let(:element) { RedClothParslet::Ast::Strong.new("", {:class=>'myclass', :id=>'my-id'}) }
    it { should == %{<strong class="myclass" id="my-id"></strong>} }
  end
  
  describe "pad left" do
    let(:element) { RedClothParslet::Ast::Strong.new("", {:style=>{'padding-left'=>1}}) }
    it { should == %{<strong style="padding-left:1em"></strong>} }
  end
  describe "pad right" do
    let(:element) { RedClothParslet::Ast::Strong.new("", {:style=>{'padding-right'=>1}}) }
    it { should == %{<strong style="padding-right:1em"></strong>} }
  end
  
  describe "align left" do
    let(:element) { RedClothParslet::Ast::Strong.new("", {:style=>{'align'=>'left'}}) }
    it { should == %{<strong style="text-align:left"></strong>} }
  end
  describe "align right" do
    let(:element) { RedClothParslet::Ast::Strong.new("", {:style=>{'align'=>'right'}}) }
    it { should == %{<strong style="text-align:right"></strong>} }
  end
  describe "align center" do
    let(:element) { RedClothParslet::Ast::Strong.new("", {:style=>{'align'=>'center'}}) }
    it { should == %{<strong style="text-align:center"></strong>} }
  end
  describe "align justify" do
    let(:element) { RedClothParslet::Ast::Strong.new("", {:style=>{'align'=>'justify'}}) }
    it { should == %{<strong style="text-align:justify"></strong>} }
  end
  
  describe "pad and align" do
    let(:element) { RedClothParslet::Ast::Strong.new("", {:style=>{"align"=>"left", "padding-left"=>1}}) }
    it { should include("padding-left:1em") }
    it { should include("align:left") }
  end
  
  
end
