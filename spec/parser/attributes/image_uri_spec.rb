describe RedClothParslet::Parser::Attributes::ImageUri do
  let(:parser) { described_class.new }

  describe "matched parentheses" do
    it { should_not parse("http://redcloth.org/text(ile)") }
    it { should parse("http://redcloth.org/text(ile).html") }
    it { should parse("http://redcloth.org/text(ile)/") }
    it { should parse("http://redcloth.org/text(ile)#") }
    it { should_not parse("http://redcloth.org/#foo(bar)") }
    it { should_not parse("/foo(bar)") }
    it { should parse("/foo(bar)/") }
    it { should_not parse("foo(bar)") }
    it { should parse("foo(t);bar") }
    it { should parse("foo;bar(none)baz") }
    it { should parse("index?foo=bar(none)baz") }
    it { should_not parse("#foo(bar)") }
  end
end
