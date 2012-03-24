describe RedClothParslet::Parser::Attributes::NongreedyUri do
  let(:parser) { described_class.new }
  
  # Though technically valid, punctuation is not allowed at the end of a URL in
  # the context of inline Textile.
  describe "termination" do
    
    it { should parse("http://red.cloth.org") }
    it { should parse("http://redcloth.org./") }
    
    %w(. !).each do |punct|
      it { should parse("http://redcloth.org/text#{punct}ile") }
      it { should parse("http://redcloth.org/text#{punct}ile.html") }
      it { should parse("http://redcloth.org/text#{punct}ile/") }
      it { should parse("http://redcloth.org/#{punct}#") }
      it { should parse("http://redcloth.org/#foo#{punct}bar") }
      it { should parse("/foo#{punct}bar") }
      it { should parse("/foo#{punct}/") }
      it { should parse("foo#{punct}bar") }
      it { should parse("foo#{punct};bar") }
      it { should parse("foo;bar#{punct}baz") }
      it { should parse("index?foo=bar#{punct}baz") }
    end
  
    [".", "!", ")"].each do |punct|
      it { should_not parse("http://redcloth.org#{punct}") }
      it { should_not parse("http://redcloth.org/#{punct}") }
      it { should_not parse("http://redcloth.org/textile#{punct}") }
      it { should_not parse("http://redcloth.org/textile.html#{punct}") }
      it { should_not parse("http://redcloth.org/textile/#{punct}") }
      it { should_not parse("http://redcloth.org/##{punct}") }
      it { should_not parse("http://redcloth.org/#foo#{punct}") }
      it { should_not parse("/foo#{punct}") }
      it { should_not parse("/foo/#{punct}") }
      it { should_not parse("foo#{punct}") }
      it { should_not parse("foo;bar#{punct}") }
      it { should_not parse("index?foo=bar#{punct}") }
    end
  end
  
  describe "matched parentheses" do
    it { should parse("http://redcloth.org/text(ile)") }
    it { should parse("http://redcloth.org/text(ile).html") }
    it { should parse("http://redcloth.org/text(ile)/") }
    it { should parse("http://redcloth.org/text(ile)#") }
    it { should parse("http://redcloth.org/#foo(bar)") }
    it { should parse("/foo(bar)") }
    it { should parse("/foo(bar)/") }
    it { should parse("foo(bar)") }
    it { should parse("foo(t);bar") }
    it { should parse("foo;bar(none)baz") }
    it { should parse("index?foo=bar(none)baz") }
    it { should parse("#foo(bar)") }
  end
end
