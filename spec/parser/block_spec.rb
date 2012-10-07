describe RedClothParslet::Parser::Block do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }

  describe "undecorated paragraphs" do
    it { should parse("Just plain text.").with(transform).
         as(p("Just plain text.")) }

    it { should parse("Trailing newline.\n").with(transform).
         as(p("Trailing newline.")) }

    context "containing inline HTML tag" do
      it { should parse('<img src="test.jpg" alt="test" />').with(transform).
           as(p(html_tag('<img src="test.jpg" alt="test" />'))) }
    end
  end

  describe "explicit paragraphs" do
    it { should parse("p. This is a paragraph.").with(transform).
         as(p("This is a paragraph.")) }

    context "with attributes" do
      it { should parse("p(myclass). This is a paragraph.").with(transform).
           as(p("This is a paragraph.", {:class=>'myclass'})) }
    end
  end

  describe "successive paragraphs" do
    it { should parse("One paragraph.\n\nTwo.").with(transform).
         as([p("One paragraph."), p("Two.")]) }

    it { should parse("p. Double.\n\np. Trouble.").with(transform).
         as([p("Double."), p("Trouble.")]) }

    it { should parse("Mix it up.\n\np. Just a bit.\n\nNo worries, mate.").with(transform).
         as([p("Mix it up."),
             p("Just a bit."),
             p("No worries, mate.")]) }
  end

  describe "extended quote" do
    it { should parse(%Q{"This is part of a multi-paragraph quote}).with(transform).
         as(p(%Q{"This is part of a multi-paragraph quote}, :possible_unfinished_quote_paragraph => true))
    }
  end

  describe "extended blocks" do
    it { should parse("p.. This is a paragraph.\n\nAnd so is this.").with(transform).
         as([p("This is a paragraph."), p("And so is this.")]) }

    it { should parse("div.. This is a div.\n\nAnd so is this.\n\np. Return to paragraph.").with(transform).
         as([div("This is a div."), div("And so is this."), p("Return to paragraph.")]) }

    it { should parse("bq.. This is a paragraph in a blockquote.\n\nAnd so is this.").with(transform).
         as(blockquote(
           p("This is a paragraph in a blockquote."),
           p("And so is this.")
    )) }
    %w(div notextile pre p).each do |block_type|
      its(:next_block_start) { should parse("#{block_type}. ") }
      its(:next_block_start) { should parse("#{block_type}.. ") }
    end

    it { should parse("notextile.. Don't touch this!\n\nOr this!").with(transform).
         as(notextile("Don't touch this!\n\nOr this!")) }
  end

  describe "list start in a paragraph" do
    it { should parse("Two for the price of one!\n* Offer not valid in Alaska").with(transform).
         as(p("Two for the price of one!\n* Offer not valid in Alaska")) }
  end

  describe "Block quote" do
    it { should parse("bq. Injustice anywhere is a threat to justice everywhere.").with(transform).
         as(blockquote(p("Injustice anywhere is a threat to justice everywhere."))) }

    context "with attributes" do
      it { should parse("bq(myclass). This is a blockquote.").with(transform).
           as(blockquote(p("This is a blockquote."), {:class=>'myclass'})) }
    end
  end

  describe "notextile block" do
    it { should parse("<notextile>\nsomething\n</notextile>").with(transform).
         as(notextile("something")) }
    it { should parse("notextile. something").with(transform).
         as(notextile("something")) }
  end

  describe "blockcode" do
    it { should parse("bc. def leopard()\n\t'prrrrr'\nend").with(transform).
         as(blockcode("def leopard()\n\t'prrrrr'\nend")) }
  end

  describe "headings" do
    (1..6).each do |num|
      it { should parse("h#{num}. Heading #{num}").with(transform).
           as(RedClothParslet::Ast.const_get("H#{num}").new("Heading #{num}")) }
    end
  end

  describe "div" do
    it { should parse("div. inside").with(transform).
         as(div("inside")) }
  end

  describe "pre" do
    it { should parse("pre. Preformatted").with(transform).
         as(pre("Preformatted")) }

    context "when extended" do
      it { should parse("pre.. Preformatted\n\nStill preformatted").with(transform).
           as(pre("Preformatted\n\nStill preformatted")) }
    end
  end

  describe "horizontal rules" do
    it { should parse("***").with(transform).
         as(hr()) }
    it { should parse("---").with(transform).
         as(hr()) }
    it { should parse("___").with(transform).
         as(hr()) }
    it { should parse("hr. ").with(transform).
         as(hr()) }
    it { should parse("hr(class).").with(transform).
         as(hr({:class => 'class'})) }
  end

  describe "hard break" do
    it { should parse("br(class).").with(transform).
         as(br({:class => 'class'})) }
  end

  describe "footnote" do
    it { should parse("fn1. A footnote").with(transform).
         as(footnote("A footnote", :number => "1")) }

    it { should parse("fn1(myclass). A footnote").with(transform).
         as(footnote("A footnote", :number => "1", :class => "myclass")) }
  end

  context "link alias" do
    let!(:link_aliases) { {} }
    it "should set itself in the link_aliases hash" do
      parse_tree = subject.parse(%{[redcloth]http://redcloth.org})
      transform.apply(parse_tree, :link_aliases => link_aliases)
      link_aliases.should have_key("redcloth")
      link_aliases["redcloth"].should == "http://redcloth.org"
    end
  end

  context "html" do
    it { should parse('<!-- comment -->').with(transform).
         as(html_tag('<!-- comment -->')) }
  end
end
