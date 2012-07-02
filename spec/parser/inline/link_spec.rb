describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }

  describe "#link" do
    it "should parse a basic link" do
      parser.link.should parse('"Google":http://google.com').with(transform).as(link("Google", {:href=>"http://google.com"}))
    end

    it "should parse link with attributes" do
      parser.link.should parse('"(appropriate)RedCloth":http://redcloth.org').with(transform).as(link("RedCloth", {:href=>"http://redcloth.org", :class=>"appropriate"}))
    end

    it "should parse link with space after attributes" do
      parser.link.should parse('"(link) text(link title)":http://example.com/').with(transform).
        as(link("text", :class => "link", :href => "http://example.com/", :title => "link title"))
    end

    it "should parse link with title" do
      parser.link.should parse('"link text(with title)":http://example.com/').with(transform).
        as(link("link text", :href => "http://example.com/", :title => "with title"))
    end

    it "should parse link with space before title" do
      parser.link.should parse('"link text (with title)":http://example.com/').with(transform).
        as(link("link text", :href => "http://example.com/", :title => "with title"))
    end

    it "should parse a parenthetical link" do
      parser.link.should parse('"(whatever)":http://example.com/').with(transform).
        as(link("(whatever)", :href => "http://example.com/"))
    end
  end

  describe "#link_title" do
    it "should parse a link title" do
      parser.link_title.should parse('(link title)').with(transform).
        as({:title => ["link title"]})
    end
  end

  it "should parse a link containing a colon" do
    parser.link.should parse('"Packrat Parsing: Simple, Powerful, Lazy, Linear Time":http://bford.info/pub/lang/packrat-icfp02/').with(transform).as(link("Packrat Parsing: Simple, Powerful, Lazy, Linear Time", {:href=>"http://bford.info/pub/lang/packrat-icfp02/"}))
  end

  it { should parse(%{"Red\nCloth":http://redcloth.org/}).with(transform).
       as(link("Red\nCloth", {:href=>"http://redcloth.org/"}))
  }

  context "link in context" do
    it { should parse(%{See "Wikipedia":http://wikipedia.org/ for more.}).with(transform).
         as(["See ", 
             link("Wikipedia", {:href=>"http://wikipedia.org/"}),
             " for more."])
    }
  end

  context "link at the end of a sentence" do
    it { should parse(%{Visit "Apple":http://apple.com/.}).with(transform).
         as(["Visit ", 
             link("Apple", {:href=>"http://apple.com/"}), 
             "."])
    }
  end

  context "in brackets" do
    it { should parse(%{["Wikipedia article about Textile":http://en.wikipedia.org/wiki/Textile_(markup_language)]}).with(transform).
         as([link("Wikipedia article about Textile", {:href=>"http://en.wikipedia.org/wiki/Textile_(markup_language)"})])
    }
  end

  context "image link" do
    it { should parse(%{!openwindow1.gif!:http://hobix.com/}).with(transform).
         as([link(img([], {:src=>"openwindow1.gif", :alt => ""}), {:href => "http://hobix.com/"})])
    }
  end
end
