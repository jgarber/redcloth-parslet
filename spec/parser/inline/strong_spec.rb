describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  
  describe "#strong" do
    it "should consume a strong word" do
      parser.strong.should parse('*hey*')
    end

    it "should consume a strong phrase" do
      parser.strong.should parse('*hey now!*')
    end
    
    it "should allow standalone asterisks" do
      parser.strong.should parse('*Five * five is twenty-five*').
        as({:inline=>"*", :content=>[{:s=>"Five"}, {:s=>" *"}, {:s=>" "}, {:s=>"five"}, {:s=>" "}, {:s=>"is"}, {:s=>" "}, {:s=>"twenty-five"}]})
    end
    
    it "should pass internal strong_start as plain text" do
      parser.strong.should parse('*A little *pearl here.*').
        as({:inline=>"*", :content=>[{:s=>"A"}, {:s=>" "}, {:s=>"little"}, {:s=>" "}, {:s=>"*pearl"}, {:s=>" "}, {:s=>"here."}]})
    end
    
    it "should not parse strong phrase containing strong_end" do
      parser.strong.should_not parse('*Another pearl* there.*')
    end
    
    it "should parse em contents" do
      parser.strong.should parse("*This is _really_ strong!*").
        as({:inline=>"*", :content=>[{:s=>"This"}, {:s=>" "}, {:s=>"is"}, {:s=>" "}, {:inline=>"_", :content=>[{:s=>"really"}]}, {:s=>" "}, {:s=>"strong!"}]})
    end
  end
  
  context "strong phrase" do
    it { should parse("*strong phrase*").
      as([{:inline=>"*", :content=>[{:s=>"strong"}, {:s=>" "}, {:s=>"phrase"}]}]) }
    
    it "should parse a strong word surrounded by plain text" do
      subject.should parse("plain *strong* plain").
      as([{:s=>"plain"}, {:s=>" "}, 
          {:inline=>"*", :content=>[{:s=>"strong"}]}, 
          {:s=>" "}, {:s=>"plain"}])
    end
    
    it "should parse a strong phrase surrounded by plain text" do
      subject.should parse("plain *strong phrase* plain").
      as([{:s=>"plain"}, {:s=>" "}, 
          {:inline=>"*", :content=>[{:s=>"strong"}, {:s=>" "}, {:s=>"phrase"}]}, 
          {:s=>" "}, {:s=>"plain"}])
    end
    
    it "should allow a strong phrase at the end of a sentence before punctuation" do
      subject.should parse("Are you *veg*an*?").
        as([{:s=>"Are"}, {:s=>" "}, {:s=>"you"}, {:s=>" "}, {:inline=>"*", :content=>[{:s=>"veg*an"}]}, {:s=>"?"}])
    end
    
    it "should parse a phrase with standalone asterisks that is not a strong phrase" do
      subject.should parse("yes * we * can").
        as([{:s=>"yes"}, {:s=>" "}, {:s=>"*"}, {:s=>" "}, {:s=>"we"}, {:s=>" "}, {:s=>"*"}, {:s=>" "}, {:s=>"can"}])
    end

    it "should parse a phrase with asterisky words that is not a strong phrase" do
      subject.should parse("The veg*an options are for veg*ans only.").
        as([{:s=>"The"}, {:s=>" "}, {:s=>"veg*an"}, {:s=>" "}, {:s=>"options"}, {:s=>" "}, {:s=>"are"}, {:s=>" "}, {:s=>"for"}, {:s=>" "}, {:s=>"veg*ans"}, {:s=>" "}, {:s=>"only."}])
    end

    it "should parse a phrase that is not a strong because it has space at the end" do
      subject.should parse("yeah *that's * it!").
        as([{:s=>"yeah"}, {:s=>" "}, {:s=>"*that's"}, {:s=>" "}, {:s=>"*"}, {:s=>" "}, {:s=>"it!"}])
    end
    
    it "should parse a phrase that is not a strong because it has space at the beginning" do
      subject.should parse("oh, * here* it is!").
        as([{:s=>"oh,"}, {:s=>" "}, {:s=>"*"}, {:s=>" "}, {:s=>"here*"}, {:s=>" "}, {:s=>"it"}, {:s=>" "}, {:s=>"is!"}])
    end
  end
  
end