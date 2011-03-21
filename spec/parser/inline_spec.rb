describe RedClothParslet::Parser::InlineParser do
  let(:parser) { described_class.new }
  
  context "plain text" do
    it { should parse("Just plain text.").
      as({:s => "Just plain text."}) }

    it { should parse("One sentence. Two.").
      as({:s => "One sentence. Two."}) }
  end
  
  context "strong phrase" do
    it { should parse("*strong phrase*").
      as({:strong => {:s => "strong phrase"}}) }
    
    it { should parse("plain *strong* plain", {:trace => true}).
      as([{:s => "plain "}, 
          {:strong => {:s => "strong"}},
          {:s => " plain"}]) }
    
    it { should parse("plain *strong phrase* plain").
      as([{:s => "plain "}, 
          {:strong => {:s => "strong phrase"}},
          {:s => " plain"}]) }
    
    it { should parse("yes * we * can").
      as({:s => "yes * we * can"}) }

    it { should parse("yeah *that's * it!").
      as({:s => "yeah *that's * it!"}) }
  end
  
  # describe "strong" do
  #   it "should parse a strong phrase" do
  #     parse("*strong phrase*").should ==
  #       [[:strong, {}, ["strong phrase"]]]
  #   end
  #   
  #   it "should parse a strong phrase surrounded by plain text" do
  #     parse("plain *strong phrase* plain").should ==
  #       ["plain ", [:strong, {}, ["strong phrase"]], " plain"]
  #   end
  #   
  #   it "should allow a strong phrase at the end of a sentence before punctuation" do
  #     parse("Are you *veg*an*?").should ==
  #       ["Are you ", [:strong, {}, ["veg*an"]], "?"]
  #   end
  #   
  # end
  
end