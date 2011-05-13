describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "#em" do
    it "should consume an emphasized word" do
      parser.em.should parse('_wow_')
    end

    it "should consume an emphasized phrase" do
      parser.em.should parse('_gee whiz!_')
    end
    
    it "should pass internal em_start as plain text" do
      parser.em.should parse('_Written by _why the lucky stiff_').with(transform).
        as(RedClothParslet::Ast::Em.new("Written by _why the lucky stiff"))
    end
    
    it "should not parse an emphasized phrase containing em_end" do
      parser.em.should_not parse('_the mouse_ has a tail_')
    end
    
    context "with attributes" do
      it { should parse("_(foo)This is emphasized._").with(transform).
        as([RedClothParslet::Ast::Em.new("This is emphasized.", {:class=>"foo"})])
      }
    end
  end
  
  context "em phrase" do
        
    it { should parse("_em phrase_").with(transform).
      as([RedClothParslet::Ast::Em.new("em phrase")]) }
    
    it "should parse an emphasized word surrounded by plain text" do
      subject.should parse("plain _em_ plain").with(transform).
      as(["plain ", 
          RedClothParslet::Ast::Em.new("em"), 
          " plain"])
    end
    
    it "should parse an emphasized phrase surrounded by plain text" do
      subject.should parse("plain _em phrase_ plain").with(transform).
      as(["plain ", 
          RedClothParslet::Ast::Em.new("em phrase"), 
          " plain"])
    end
    
    it "should allow an emphasized phrase at the end of a sentence before punctuation" do
      subject.should parse("Are you _fo' realz_?").with(transform).
        as(["Are you ", RedClothParslet::Ast::Em.new("fo' realz"), "?"])
    end

    it "should parse a phrase with underscored words that is not an emphasized phrase" do
      subject.should parse("The form_test_helper plugin was my first.").with(transform).
        as(["The form_test_helper plugin was my first."])
    end

    it "should parse a phrase that is not emphasized because it has space at the end" do
      subject.should parse("no _em _ here!").with(transform).
        as(["no _em _ here!"])
    end
    
    it "should parse a phrase that is not emphasized because it has space at the beginning" do
      subject.should parse("surely you _ can't_ be serious").with(transform).
        as(["surely you _ can't_ be serious"])
    end
  end
  
end
