describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  
  context "plain text" do
    it { should parse("Just plain text.").
      as(["Just plain text."]) }

    it { should parse("One sentence. Two.").
      as(["One sentence. Two."]) }
  end
  
  context "em inside strong" do
    it { should parse("*This is _really_ strong!*").
      as([{:inline=>"*", :content=>["This is ", {:inline=>"_", :content=>["really"]}, " strong!"]}])
    }
  end

  context "strong inside em" do
    it { should parse("_No tengo *ningún* idea._").
      as([{:inline=>"_", :content=>["No tengo ", {:inline=>"*", :content=>["ningún"]}, " idea."]}])
    }
  end
  
end