describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  
  describe "#link" do
    it "should parse a basic link" do
      parser.link.should parse('"Google":http://google.com').as({:inline=>'":', :content=>["Google"], :href=>"http://google.com"})
    end

    it "should parse link with attributes" do
      parser.link.should parse('"(appropriate)RedCloth":http://redcloth.org').as({:inline=>'":', :content=>["RedCloth"], :attributes=>[{:class=>'appropriate'}], :href=>"http://redcloth.org"})
    end
  end
  
  context "link in context" do
    it { should parse(%{See "Wikipedia":http://wikipedia.org/ for more.}).
      as(["See ", 
          {:inline=>'":', :content=>["Wikipedia"], :href=>"http://wikipedia.org/"}, 
          " for more."])
    }
  end
  
  context "link at the end of a sentence" do
    it { should parse(%{Visit "Apple":http://apple.com/.}).
      as(["Visit ", 
          {:inline=>'":', :content=>["Apple"], :href=>"http://apple.com/"}, 
          "."])
    }
  end
  
end
