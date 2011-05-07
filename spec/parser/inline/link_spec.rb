describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  
  describe "#link" do
    it "should consume a basic link" do
      parser.link.should parse('"Google":http://google.com')
    end

  end
  
end
