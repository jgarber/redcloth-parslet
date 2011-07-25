describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "#acronym" do
    it "should consume an acronym" do
      parser.acronym.should parse("CSS(Cascading Style Sheets)")
    end

    it "should consume a two-letter acronym" do
      parser.acronym.should parse("AI(Artificial Intelligence)")
    end
  end
  
  context "acronym in a phrase" do
        
    it { should parse("I use CSS(Cascading Style Sheets).").with(transform).
      as(["I use ", RedClothParslet::Ast::Acronym.new("CSS", {:title => "Cascading Style Sheets"}), "."]) }
    
      it { should parse("It employs AI(artificial intelligence) processing.").with(transform).
        as(["It employs ", RedClothParslet::Ast::Acronym.new("AI", {:title => "artificial intelligence"}), " processing."]) }

  end
  
end
