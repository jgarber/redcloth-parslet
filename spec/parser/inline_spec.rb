describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  
  context "plain text" do
    it { should parse("Just plain text.").
      as([{:s=>"Just"}, {:s=>" "}, {:s=>"plain"}, {:s=>" "}, {:s=>"text."}]) }

    it { should parse("One sentence. Two.").
      as([{:s=>"One"}, {:s=>" "}, {:s=>"sentence."}, {:s=>" "}, {:s=>"Two."}]) }
  end
  
  context "em inside strong" do
    it { should parse("*This is _really_ strong!*").
      as([{:inline=>"*", :content=>[{:s=>"This"}, {:s=>" "}, {:s=>"is"}, {:s=>" "}, {:inline=>"_", :content=>[{:s=>"really"}]}, {:s=>" "}, {:s=>"strong!"}]}])
    }
  end
  
end