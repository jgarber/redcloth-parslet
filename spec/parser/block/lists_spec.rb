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

  describe "dl" do
    its(:dt) { should parse("- octopus").with(transform).
               as(dt("octopus")) }
    its(:dd) { should parse(":= a cat with eight legs").with(transform).
               as(dd("a cat with eight legs")) }
    its(:definition) { should parse("- hamlet := a small pig").with(transform).
               as([dt("hamlet"), dd("a small pig")]) }
    its(:definition) { should parse("- gum:=hair adhesive").with(transform).
               as([dt("gum"), dd("hair adhesive")]) }

    its(:dt) { should parse("- line-spanning\nterm").with(transform).
               as(dt("line-spanning\nterm")) }
    its(:dd) { should parse(":= line-spanning\ndefinition").with(transform).
               as(dd("line-spanning\ndefinition")) }

    its(:definition_list) { should_not parse("- one\n- two\n- three") }

    it { should parse("- rabbit\n- bunny := the cutest rodent you've ever seen").with(transform).
         as(dl( dt("rabbit"), dt("bunny"), dd("the cutest rodent you've ever seen") )) }

    it { should parse("- hangover := the wrath of grapes\n- raisin := a grape with a sunburn").with(transform).
         as(dl( dt("hangover"), dd("the wrath of grapes"), dt("raisin"), dd("a grape with a sunburn") )) }
    it { should parse("here is a long definition\n\n- some term := \n*sweet*\n\nyes\n\nok =:\n- regular term := no").with(transform).
         as([p("here is a long definition"), dl([ dt("some term"), dd([ p(strong("sweet")), p("yes"), p("ok") ]), dt("regular term"), dd("no") ])]) }
    it { should parse("- textile\n- fabric\n- cloth").with(transform).
         as([p("- textile\n- fabric\n- cloth") ]) }

    describe "inline content" do
      its(:definition_list_content) { should parse("gossip") }
      its(:definition_list_content) { should_not parse("hearsay:=") }
    end
  end
end
