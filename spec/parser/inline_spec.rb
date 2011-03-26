describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  
  context "plain text" do
    it { should parse("Just plain text.").
      as([{:s => "Just plain text."}]) }

    it { should parse("One sentence. Two.").
      as([{:s => "One sentence. Two."}]) }
  end
  
  context "em inside strong" do
    it { should parse("*This is _really_ strong!*").
      as([{:inline => '*', :c => [
        {:s => "This is"}, {:pre => " ", :inline => "_", :c => [:s => "really"]}, {:pre => " ", :s => "strong!"}
      ]}])
    }
  end
  
end