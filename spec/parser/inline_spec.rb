describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  
  context "plain text" do
    it { should parse("Just plain text.").
      as([{:s => "Just plain text."}]) }

    it { should parse("One sentence. Two.").
      as([{:s => "One sentence. Two."}]) }
  end
  
  describe "#strong" do
    it "should consume a strong word" do
      parser.strong.should parse('*hey*')
    end

    it "should consume a strong phrase" do
      parser.strong.should parse('*hey now!*')
    end
  end
  
  context "strong phrase" do
    it { should parse("*strong phrase*").
      as([{:inline => "*", :content => [:s => "strong phrase"]}]) }
    
    it "should parse a strong word surrounded by plain text" do
      subject.should parse("plain *strong* plain").
      as([{:s => "plain "}, 
          {:inline => "*", :content => [{:s => "strong"}]},
          {:s => " plain"}])
    end
    
    it "should parse a strong phrase surrounded by plain text" do
      subject.should parse("plain *strong phrase* plain").
      as([{:s => "plain "}, 
          {:inline => "*", :content => [{:s => "strong phrase"}]},
          {:s => " plain"}])
    end
    
    it "should allow a strong phrase at the end of a sentence before punctuation" do
      subject.should parse("Are you *veg*an*?", {:trace => true}).
        as([{:s => "Are you "}, {:inline => "*", :content => [:s => "veg*an"]}, {:s => "?"}])
    end
    
    it "should parse a phrase with standalone asterisks that is not a strong phrase" do
      subject.should parse("yes * we * can").
        as([{:s => "yes * we * can"}])
    end

    it "should parse a phrase with asterisky words that is not a strong phrase" do
      subject.should parse("The veg*an options are for veg*ans only.").
        as([{:s => "The veg*an options are for veg*ans only."}])
    end

    it "should parse a phrase that is not a strong because it has space at the end" do
      subject.should parse("yeah *that's * it!").
        as([{:s => "yeah *that's * it!"}])
    end
    
    it "should parse a phrase that is not a strong because it has space at the beginning" do
      subject.should parse("oh, * here* it is!").
        as([{:s => "oh, * here* it is!"}])
    end
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