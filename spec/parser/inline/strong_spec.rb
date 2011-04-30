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
        as({:inline=>"*", :content=>["Five * five is twenty-five"]})
    end
    
    it "should pass internal strong_start as plain text" do
      parser.strong.should parse('*A little *pearl here.*').
        as({:inline=>"*", :content=>["A little *pearl here."]})
    end
    
    it "should not parse strong phrase containing strong_end" do
      parser.strong.should_not parse('*Another pearl* there.*')
    end
    
    it "should parse em contents" do
      parser.strong.should parse("*This is _really_ strong!*").
        as({:inline=>"*", :content=>["This is ", {:inline=>"_", :content=>["really"]}, " strong!"]})
    end
    
    context "with attributes" do
      it { should parse("*(widget)This is strong!*").
        as([{:inline=>"*", :content=>["This is strong!"], :attributes=>[{:class=>"widget"}]}])
      }
    end
  end
  
  context "strong phrase" do
    it { should parse("*strong phrase*").
      as([{:inline=>"*", :content=>["strong phrase"]}]) }
    
    it "should parse a strong word surrounded by plain text" do
      subject.should parse("plain *strong* plain").
      as(["plain ", 
          {:inline=>"*", :content=>["strong"]}, 
          " plain"])
    end
    
    it "should parse a strong phrase surrounded by plain text" do
      subject.should parse("plain *strong phrase* plain").
      as(["plain ", 
          {:inline=>"*", :content=>["strong phrase"]}, 
          " plain"])
    end
    
    it "should allow a strong phrase at the end of a sentence before punctuation" do
      subject.should parse("Are you *veg*an*?").
        as(["Are you ", {:inline=>"*", :content=>["veg*an"]}, "?"])
    end
    
    it "should parse a phrase with standalone asterisks that is not a strong phrase" do
      subject.should parse("yes * we * can").
        as(["yes * we * can"])
    end

    it "should parse a phrase with asterisky words that is not a strong phrase" do
      subject.should parse("The veg*an options are for veg*ans only.").
        as(["The veg*an options are for veg*ans only."])
    end

    it "should parse a phrase that is not a strong because it has space at the end" do
      subject.should parse("yeah *that's * it!").
        as(["yeah *that's * it!"])
    end
    
    it "should parse a phrase that is not a strong because it has space at the beginning" do
      subject.should parse("oh, * here* it is!").
        as(["oh, * here* it is!"])
    end
  end
  
end
