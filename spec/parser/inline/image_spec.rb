describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "#image" do
    it "should parse a basic image" do
      parser.image.should parse('!http://hobix.com/sample.jpg!').with(transform).as(RedClothParslet::Ast::Img.new([], {:src=>"http://hobix.com/sample.jpg"}))
    end

    it "should parse image with attributes" do
      parser.image.should parse('!(rabid)bunny.gif!').with(transform).as(RedClothParslet::Ast::Img.new([], {:src=>"bunny.gif", :class=>"rabid"}))
    end

    it "should parse image with alt" do
      parser.image.should parse('!openwindow1.gif(Bunny.)!').with(transform).as(RedClothParslet::Ast::Img.new([], {:src=>"openwindow1.gif", :alt=>"Bunny."}))
    end

    it "should parse image with align" do
      parser.image.should parse('!>right.png!').with(transform).as(RedClothParslet::Ast::Img.new([], {:src=>"right.png", :style=>{'align'=>'right'}}))
    end
  end
  
  context "image in context" do
    it { should parse(%{You're a nut !smiley.png! but I like you anyway.}).with(transform).
      as(["You're a nut ", 
          RedClothParslet::Ast::Img.new([], {:src=>"smiley.png"}),
          " but I like you anyway."])
    }
  end
  
  context "link at the end of an exclamatory sentence" do
    it { should parse(%{Hi, cutie !smiley.png!!}).with(transform).
      as(["Hi, cutie ", 
          RedClothParslet::Ast::Img.new([], {:src=>"smiley.png"}), 
          "!"])
    }
  end
  
end
