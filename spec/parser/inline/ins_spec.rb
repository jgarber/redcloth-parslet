describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "#ins" do
    it "should consume an inserted word" do
      parser.ins.should parse('+wow+')
    end

    it "should consume an inserted phrase" do
      parser.ins.should parse('+gee whiz!+')
    end
    
    it "should pass internal ins_start as plain text" do
      parser.ins.should parse('+I gave a +1 to your post+').with(transform).
        as(RedClothParslet::Ast::Ins.new("I gave a +1 to your post"))
    end
    
    it "should not parse an inserted phrase containing ins_end" do
      parser.ins.should_not parse('+Do you use Google+ much?+')
    end
    
    context "with attributes" do
      it { should parse("+(foo)This is inserted.+").with(transform).
        as([RedClothParslet::Ast::Ins.new("This is inserted.", {:class=>"foo"})])
      }
    end
  end
  
  context "ins phrase" do
        
    it { should parse("+inserted phrase+").with(transform).
      as([RedClothParslet::Ast::Ins.new("inserted phrase")]) }
    
    it "should parse an inserted word surrounded by plain text" do
      subject.should parse("plain +ins+ plain").with(transform).
      as(["plain ", 
          RedClothParslet::Ast::Ins.new("ins"), 
          " plain"])
    end
    
    it "should parse an inserted phrase surrounded by plain text" do
      subject.should parse("plain +ins phrase+ plain").with(transform).
      as(["plain ", 
          RedClothParslet::Ast::Ins.new("ins phrase"), 
          " plain"])
    end
    
    it "should allow an inserted phrase at the end of a sentence before punctuation" do
      subject.should parse("Are you +serious+?").with(transform).
        as(["Are you ", RedClothParslet::Ast::Ins.new("serious"), "?"])
    end

    it "should parse a phrase with plussed words that is not an inserted phrase" do
      subject.should parse("You+me are great together.").with(transform).
        as(["You+me are great together."])
    end

    it "should parse a phrase that is not inserted because it has space at the end" do
      subject.should parse("no +ins + here!").with(transform).
        as(["no +ins + here!"])
    end
    
    it "should parse a phrase that is not insphasized because it has space at the beginning" do
      subject.should parse("surely you are + not+ serious").with(transform).
        as(["surely you are + not+ serious"])
    end
  end
  
end
