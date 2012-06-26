describe RedClothParslet::Formatter::HTML do
  subject { described_class.new(:sort_attributes => true).convert(element) }

  describe "class" do
    let(:element) { strong("", :class=>'myclass') }
    it { should == %{<strong class="myclass"></strong>} }
  end

  describe "class + id" do
    let(:element) { strong("", {:class=>'myclass', :id=>'my-id'}) }
    it { should == %{<strong class="myclass" id="my-id"></strong>} }
  end

  describe "style" do
    let(:element) { strong("", {:style=>{'color'=>'red'}}) }
    it { should == %{<strong style="color:red;"></strong>} }
  end
  describe "style + padding" do
    let(:element) { strong("", {:style=>{'color'=>'red','padding-left'=>1}}) }
    it { should == %{<strong style="color:red;padding-left:1em;"></strong>} }
  end

  describe "pad left" do
    let(:element) { strong("", {:style=>{'padding-left'=>1}}) }
    it { should == %{<strong style="padding-left:1em;"></strong>} }
  end
  describe "pad right" do
    let(:element) { strong("", {:style=>{'padding-right'=>1}}) }
    it { should == %{<strong style="padding-right:1em;"></strong>} }
  end

  describe "align left" do
    let(:element) { strong("", {:style=>{'align'=>'left'}}) }
    it { should == %{<strong style="text-align:left;"></strong>} }
  end
  describe "align right" do
    let(:element) { strong("", {:style=>{'align'=>'right'}}) }
    it { should == %{<strong style="text-align:right;"></strong>} }
  end
  describe "align center" do
    let(:element) { strong("", {:style=>{'align'=>'center'}}) }
    it { should == %{<strong style="text-align:center;"></strong>} }
  end
  describe "align justify" do
    let(:element) { strong("", {:style=>{'align'=>'justify'}}) }
    it { should == %{<strong style="text-align:justify;"></strong>} }
  end

  describe "pad and align" do
    let(:element) { strong("", {:style=>{"align"=>"left", "padding-left"=>1}}) }
    it { should include("padding-left:1em") }
    it { should include("align:left") }
  end

  describe "language designation" do
    let(:element) { strong("", {:lang => 'fr'}) }
    it { should include(%Q{lang="fr"}) }
  end

end
