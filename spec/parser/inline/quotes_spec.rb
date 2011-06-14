describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "#double_quoted_phrase" do
    it "should consume a double-quoted phrase" do
      parser.double_quoted_phrase.should parse('"Wow"')
    end
  end
  describe "quotes" do
    it { should parse(%Q{"Hey!"}).with(transform).
      as([RedClothParslet::Ast::DoubleQuotedPhrase.new(["Hey!"])])
    }
  end
  
end
