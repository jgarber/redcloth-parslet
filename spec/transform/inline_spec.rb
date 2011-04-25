describe RedClothParslet::Transform::Inline do
  let(:transform) { described_class.new(Nokogiri::HTML::Document.new) }
  subject { transform.apply(tree).to_html }
    
  describe "plain text" do
    let(:tree) { {:s => "Plain text"} }
    it { should == "Plain text" }
  end
  
  describe "strong" do
    let(:tree) { {:inline=>"*", :content=>[{:s => "inside"}]} }
    it { should == "<strong>inside</strong>" }
  end

  describe "em" do
    let(:tree) { {:inline=>"_", :content=>[{:s => "inside"}]} }
    it { should == "<em>inside</em>" }
  end
  
  describe "em inside strong" do
    let(:tree) { {:inline=>"*", :content=>[{:inline=>"_", :content=>[{:s => "inside"}]}]} }
    it { should == "<strong><em>inside</em></strong>" }
  end

end