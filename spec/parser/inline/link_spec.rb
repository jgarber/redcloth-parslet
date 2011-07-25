describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "#double_quoted_phrase_or_link" do
    it "should parse a basic link" do
      parser.double_quoted_phrase_or_link.should parse('"Google":http://google.com').with(transform).as(RedClothParslet::Ast::Link.new(["Google"], {:href=>"http://google.com"}))
    end

    it "should parse link with attributes" do
      parser.double_quoted_phrase_or_link.should parse('"(appropriate)RedCloth":http://redcloth.org').with(transform).as(RedClothParslet::Ast::Link.new(["RedCloth"], {:href=>"http://redcloth.org", :class=>"appropriate"}))
    end
  end
  
  context "link in context" do
    it { should parse(%{See "Wikipedia":http://wikipedia.org/ for more.}).with(transform).
      as(["See ", 
          RedClothParslet::Ast::Link.new(["Wikipedia"], {:href=>"http://wikipedia.org/"}),
          " for more."])
    }
  end
  
  context "link at the end of a sentence" do
    it { should parse(%{Visit "Apple":http://apple.com/.}).with(transform).
      as(["Visit ", 
          RedClothParslet::Ast::Link.new(["Apple"], {:href=>"http://apple.com/"}), 
          "."])
    }
  end
  
  context "image link" do
    it { should parse(%{!openwindow1.gif!:http://hobix.com/}).with(transform).
      as([RedClothParslet::Ast::Link.new(RedClothParslet::Ast::Img.new([], {:src=>"openwindow1.gif", :alt => ""}), {:href => "http://hobix.com/"})])
    }
  end
  
end
