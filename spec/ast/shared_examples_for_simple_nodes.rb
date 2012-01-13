shared_examples "a simple node" do
  subject { described_class.new(string) }
  
  its(:to_s) { should == string }
  it { should == described_class.new(string) }
  it { should == string }
  
end