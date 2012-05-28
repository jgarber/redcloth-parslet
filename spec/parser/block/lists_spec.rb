describe RedClothParslet::Parser::Block do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }

  describe "ul" do
    it { should parse("* one\n* two").with(transform).
         as(ul([ li(["one"]), li(["two"]) ])) }

    it { should parse("* 1\n** 1.1").with(transform).
         as(ul([ li(["1"]), ul(li(["1.1"])) ])) }
  end

  describe "ol" do
    it { should parse("# one\n# two").with(transform).
         as(ol([ li(["one"]), li(["two"]) ])) }

    it { should parse("# one\n## one-one").with(transform).
         as( ol([ li(["one"]), ol(li(["one-one"])) ])) }
  end

  context "list attributes" do
    it { should parse("(class#id)* one\n* two").with(transform).
         as(ul([ li(["one"]), li(["two"]) ], {:class=>'class', :id=>'id'})) }

    it { should parse("#7(class#id) seven\n# eight").with(transform).
         as(ol([li("seven", {:class=>'class', :id=>'id'}), li("eight")], {:start=>7})) }

    it { should parse("# one\n# two\n\n#_(class#id) three\n# four").with(transform).
         as([ol(li("one"), li("two")), ol([li("three", {:class=>'class', :id=>'id'}), li("four")], {:start=>3})]) }

    it { should parse("#8 eight\n# nine\n\n#_ ten\n# eleven").with(transform).
         as([ol([li("eight"), li("nine")], {:start=>8}), ol([li("ten"), li("eleven")], {:start=>10})]) }

    it { should_not parse("*10 times as many*").with(transform).
         as(ul([li("times as many*")], {:start => 10})) }
  end

  context "list item attributes" do
    it { should parse("*(class#id) one\n* two").with(transform).
         as(ul([ li(["one"], {:class=>'class', :id=>'id'}), li(["two"]) ])) }
  end
end
