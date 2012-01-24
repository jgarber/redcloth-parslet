describe RedClothParslet::Parser::Block do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "undecorated paragraphs" do
    it { should parse("Just plain text.").with(transform).
      as([RedClothParslet::Ast::P.new(["Just plain text."])]) }
      
    context "containing inline HTML tag" do
      it { should parse('<img src="test.jpg" alt="test" />').with(transform).
        as([RedClothParslet::Ast::P.new(RedClothParslet::Ast::HtmlTag.new('<img src="test.jpg" alt="test" />'))]) }
    end
  end

  describe "explicit paragraphs" do
    it { should parse("p. This is a paragraph.").with(transform).
      as([RedClothParslet::Ast::P.new(["This is a paragraph."])]) }
    
    context "with attributes" do
      it { should parse("p(myclass). This is a paragraph.").with(transform).
        as([RedClothParslet::Ast::P.new(["This is a paragraph."], {:class=>'myclass'})]) }
    end
  end
  
  describe "successive paragraphs" do
    it { should parse("One paragraph.\n\nTwo.").with(transform).
      as([RedClothParslet::Ast::P.new(["One paragraph."]), RedClothParslet::Ast::P.new(["Two."])]) }
    
    it { should parse("p. Double.\n\np. Trouble.").with(transform).
      as([RedClothParslet::Ast::P.new(["Double."]), RedClothParslet::Ast::P.new(["Trouble."])]) }
      
    it { should parse("Mix it up.\n\np. Just a bit.\n\nNo worries, mate.").with(transform).
      as([RedClothParslet::Ast::P.new(["Mix it up."]), 
          RedClothParslet::Ast::P.new(["Just a bit."]),
          RedClothParslet::Ast::P.new(["No worries, mate."])]) }
  end

  describe "extended blocks" do
    it { should parse("p.. This is a paragraph.\n\nAnd so is this.").with(transform).
      as([RedClothParslet::Ast::P.new("This is a paragraph."), RedClothParslet::Ast::P.new("And so is this.")]) }
    
    it { should parse("div.. This is a div.\n\nAnd so is this.\n\np. Return to paragraph.").with(transform).
      as([RedClothParslet::Ast::Div.new("This is a div."), RedClothParslet::Ast::Div.new("And so is this."), RedClothParslet::Ast::P.new("Return to paragraph.")]) }
      
    it { should parse("bq.. This is a paragraph in a blockquote.\n\nAnd so is this.").with(transform).
      as([RedClothParslet::Ast::Blockquote.new(
          RedClothParslet::Ast::P.new("This is a paragraph in a blockquote."), 
          RedClothParslet::Ast::P.new("And so is this.")
        )]) }
    %w(div notextile pre p).each do |block_type|
      its(:next_block_start) { should parse("#{block_type}. ") }
      its(:next_block_start) { should parse("#{block_type}.. ") }
    end
    
    it { should parse("notextile.. Don't touch this!\n\nOr this!").with(transform).
      as([RedClothParslet::Ast::Notextile.new("Don't touch this!\n\nOr this!")]) }
  end
  
  describe "list start in a paragraph" do
    it { should parse("Two for the price of one!\n* Offer not valid in Alaska").with(transform).
      as([RedClothParslet::Ast::P.new(["Two for the price of one!\n* Offer not valid in Alaska"])]) }
  end

  describe "Block quote" do
    it { should parse("bq. Injustice anywhere is a threat to justice everywhere.").with(transform).
      as([RedClothParslet::Ast::Blockquote.new([RedClothParslet::Ast::P.new(["Injustice anywhere is a threat to justice everywhere."])])]) }

    context "with attributes" do
      it { should parse("bq(myclass). This is a blockquote.").with(transform).
        as([RedClothParslet::Ast::Blockquote.new([RedClothParslet::Ast::P.new(["This is a blockquote."])], {:class=>'myclass'})]) }
    end
  end
  
  describe "notextile block" do
    it { should parse("<notextile>\nsomething\n</notextile>").with(transform).
      as([RedClothParslet::Ast::Notextile.new("something")]) }
    it { should parse("notextile. something").with(transform).
      as([RedClothParslet::Ast::Notextile.new("something")]) }
  end
  
  describe "headings" do
    (1..6).each do |num|
      it { should parse("h#{num}. Heading #{num}").with(transform).
        as([RedClothParslet::Ast.const_get("H#{num}").new(["Heading #{num}"])]) }
      
    end
  end
  
  describe "div" do
    it { should parse("div. inside").with(transform).
      as([RedClothParslet::Ast::Div.new(["inside"])]) }
  end
  
  describe "pre" do
    it { should parse("pre. Preformatted").with(transform).
      as([RedClothParslet::Ast::Pre.new(["Preformatted"])]) }
      
    context "when extended" do
      it { should parse("pre.. Preformatted\n\nStill preformatted").with(transform).
        as([RedClothParslet::Ast::Pre.new(["Preformatted\n\nStill preformatted"])]) }
    end
  end
  
end
