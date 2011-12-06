# encoding: UTF-8

describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  context "plain text" do
    it { should parse("Just plain text.").with(transform).
      as(["Just plain text."]) }
    
    it { should parse("One sentence. Two.").with(transform).
      as(["One sentence. Two."]) }
    
    it { should parse("Roses are red\nViolets are purple").with(transform).
      as(["Roses are red\nViolets are purple"]) }
    
  end
  
  context "em inside strong" do
    it { should parse("*This is _really_ strong!*").with(transform).
      as([RedClothParslet::Ast::Strong.new(["This is ", RedClothParslet::Ast::Em.new(["really"]), " strong!"])])
    }
  end

  context "strong inside em" do
    it { should parse("_No tengo *ningún* idea._").with(transform).
      as([RedClothParslet::Ast::Em.new(["No tengo ", RedClothParslet::Ast::Strong.new(["ningún"]), " idea."])])
    }
  end
  
  context "bold" do
    it { should parse("Could not find **Textile**.").with(transform).
      as(["Could not find ", RedClothParslet::Ast::B.new(["Textile"]), "."])
    }
  end
  
  context "italics" do
    it { should parse("I just got the weirdest feeling of __déjà vu__.").with(transform).
      as(["I just got the weirdest feeling of ", RedClothParslet::Ast::I.new(["déjà vu"]), "."])
    }
  end
  
  context "double-quoted phrase in link" do
    it { should parse(%Q{""Example"":http://example.com}).with(transform).
      as([RedClothParslet::Ast::Link.new([RedClothParslet::Ast::DoubleQuotedPhrase.new(["Example"])], {:href=>"http://example.com"})])
    }
  end

  context "link in double-quoted phrase" do
    it { should parse(%Q{""Example":http://example.com"}).with(transform).
      as([RedClothParslet::Ast::DoubleQuotedPhrase.new([RedClothParslet::Ast::Link.new(["Example"], {:href=>"http://example.com"})])])
    }
  end
  
  
end
