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
  
  describe "em inside strong" do
    let(:element) { RedClothParslet::Ast::Strong.new(RedClothParslet::Ast::Em.new("inside")) }
    it { should == "<strong><em>inside</em></strong>" }
  end
  
  describe "attributes" do
    describe "class" do
      let(:element) { RedClothParslet::Ast::Strong.new("inside", :class=>'myclass') }
      it { should == %{<strong class="myclass">inside</strong>} }
    end
    
    describe "class + id" do
      let(:element) { RedClothParslet::Ast::Strong.new("inside", {:class=>'myclass', :id=>'my-id'}) }
      it { should == %{<strong class="myclass" id="my-id">inside</strong>} }
    end
    
    describe "pad left" do
      let(:element) { RedClothParslet::Ast::Strong.new("inside", {:style=>{'padding-left'=>1}}) }
      it { should == %{<strong style="padding-left:1em">inside</strong>} }
    end
    describe "pad right" do
      let(:element) { RedClothParslet::Ast::Strong.new("inside", {:style=>{'padding-right'=>1}}) }
      it { should == %{<strong style="padding-right:1em">inside</strong>} }
    end
    
    describe "align left" do
      let(:element) { RedClothParslet::Ast::Strong.new("inside", {:style=>{'text-align'=>'left'}}) }
      it { should == %{<strong style="text-align:left">inside</strong>} }
    end
    describe "align right" do
      let(:element) { RedClothParslet::Ast::Strong.new("inside", {:style=>{'text-align'=>'right'}}) }
      it { should == %{<strong style="text-align:right">inside</strong>} }
    end
    describe "align center" do
      let(:element) { RedClothParslet::Ast::Strong.new("inside", {:style=>{'text-align'=>'center'}}) }
      it { should == %{<strong style="text-align:center">inside</strong>} }
    end
    describe "align justify" do
      let(:element) { RedClothParslet::Ast::Strong.new("inside", {:style=>{'text-align'=>'justify'}}) }
      it { should == %{<strong style="text-align:justify">inside</strong>} }
    end
    
    describe "pad and align" do
      let(:element) { RedClothParslet::Ast::Strong.new("inside", {:style=>{'padding-left'=>1, 'text-align'=>'left'}}) }
      it { should == %{<strong style="text-align:left; padding-left:1em">inside</strong>} }
    end
    
  end

end