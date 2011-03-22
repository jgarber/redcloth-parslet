describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  
  context "plain text" do
    it { should parse("Just plain text.").
      matching([{:s => "Just plain text."}]) }

    it { should parse("One sentence. Two.").
      matching([{:s => "One sentence. Two."}]) }
  end
  
  context "em inside strong" do
    it { should parse("*This is _really_ strong!*").
      matching([{:inline => '*', :c => [
        {:s => "This is"}, {:pre => " ", :inline => "_", :c => [:s => "really"]}, {:pre => " ", :s => "strong!"}
      ]}]) }
    
  end
end