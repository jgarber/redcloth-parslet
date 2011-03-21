describe RedClothParslet::Transform::Inline do
  let(:transform) { described_class.new }
  subject { transform.apply(tree) }
    
  describe "plain text" do
    let(:tree) { {:s => "Plain text"} }
    
    it { should == "Plain text" }
  end
  
  describe "strong" do
    let(:tree) { {:strong_start => {:start => "*", :content => {:s => "inside"}}, :strong_end => "*"} }
  end
end