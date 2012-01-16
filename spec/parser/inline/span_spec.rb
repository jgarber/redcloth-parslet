describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "#span" do
    it "should consume spanned word" do
      parser.span.should parse('%spanme%')
    end

    it "should consume a spanned phrase" do
      parser.span.should parse('%span me!%')
    end
    
    it "should pass internal span_start as plain text" do
      parser.span.should parse('%Start a %html block in HAML%').with(transform).
        as(RedClothParslet::Ast::Span.new("Start a %html block in HAML"))
    end
    
    it "should not parse a spanned phrase containing span_end" do
      parser.span.should_not parse('%Over 90% of statistics%')
    end
    
    context "with attributes" do
      it { should parse("%(foo)This is spanned.%").with(transform).
        as([RedClothParslet::Ast::Span.new("This is spanned.", {:class=>"foo"})])
      }

      it { should parse("%{color:red}This is spanned.%").with(transform).
        as([RedClothParslet::Ast::Span.new("This is spanned.", {:style=>"color:red"})])
      }
    end
  end
  
  context "span phrase" do
        
    it { should parse("%span phrase%").with(transform).
      as([RedClothParslet::Ast::Span.new("span phrase")]) }
    
    it "should parse a spanned word surrounded by plain text" do
      subject.should parse("plain %span% plain").with(transform).
      as(["plain ", 
          RedClothParslet::Ast::Span.new("span"), 
          " plain"])
    end
    
    it "should parse a spanned phrase surrounded by plain text" do
      subject.should parse("plain %spanned phrase% plain").with(transform).
      as(["plain ", 
          RedClothParslet::Ast::Span.new("spanned phrase"), 
          " plain"])
    end
    
    it "should allow a spanned phrase at the end of a sentence before punctuation" do
      subject.should parse("Are you %spanning me%?").with(transform).
        as(["Are you ", RedClothParslet::Ast::Span.new("spanning me"), "?"])
    end

    it "should parse a phrase that is not spanned because it has space at the end" do
      subject.should parse("no %span % here!").with(transform).
        as(["no %span % here!"])
    end
    
    it "should parse a phrase that is not spanned because it has space at the beginning" do
      subject.should parse("surely you % can't% be serious").with(transform).
        as(["surely you % can't% be serious"])
    end
  end
  
end
