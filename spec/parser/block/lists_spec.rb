describe RedClothParslet::Parser::Block do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "ul" do
    it { should parse("* one\n* two").with(transform).
      as([RedClothParslet::Ast::Ul.new([
        RedClothParslet::Ast::Li.new(["one"]), 
        RedClothParslet::Ast::Li.new(["two"])
      ])]) }

    it { should parse("* 1\n** 1.1").with(transform).
      as([
        RedClothParslet::Ast::Ul.new([
          RedClothParslet::Ast::Li.new(["1"]), 
          RedClothParslet::Ast::Ul.new(RedClothParslet::Ast::Li.new(["1.1"]))
        ])
      ]) }
  end
  
  describe "ol" do
    it { should parse("# one\n# two").with(transform).
      as([RedClothParslet::Ast::Ol.new([
        RedClothParslet::Ast::Li.new(["one"]), 
        RedClothParslet::Ast::Li.new(["two"])
      ])]) }

    it { should parse("# one\n## one-one").with(transform).
      as([
        RedClothParslet::Ast::Ol.new([
          RedClothParslet::Ast::Li.new(["one"]), 
          RedClothParslet::Ast::Ol.new(RedClothParslet::Ast::Li.new(["one-one"]))
        ])
      ]) }
  end
  
  context "list attributes" do
    it { should parse("(class#id)* one\n* two").with(transform).
      as([RedClothParslet::Ast::Ul.new([
        RedClothParslet::Ast::Li.new(["one"]), 
        RedClothParslet::Ast::Li.new(["two"])
      ], {:class=>'class', :id=>'id'})]) }
    it { should parse("#7(class#id) seven\n# eight").with(transform).
      as([RedClothParslet::Ast::Ol.new([RedClothParslet::Ast::Li.new("seven", {:class=>'class', :id=>'id'}), RedClothParslet::Ast::Li.new("eight")], {:start=>7})]) }
    it { should parse("# one\n\n#_(class#id) two").with(transform).
      as([RedClothParslet::Ast::Ol.new(RedClothParslet::Ast::Li.new("one")), RedClothParslet::Ast::Ol.new(RedClothParslet::Ast::Li.new("two", {:class=>'class', :id=>'id'}), {:start=>2})]) }
    it { should parse("#9 nine\n\n#_ ten").with(transform).
      as([RedClothParslet::Ast::Ol.new(RedClothParslet::Ast::Li.new("nine"), {:start=>9}), RedClothParslet::Ast::Ol.new(RedClothParslet::Ast::Li.new("ten"), {:start=>10})]) }
  end
  
  context "list item attributes" do
    it { should parse("*(class#id) one\n* two").with(transform).
      as([RedClothParslet::Ast::Ul.new([
        RedClothParslet::Ast::Li.new(["one"], {:class=>'class', :id=>'id'}), 
        RedClothParslet::Ast::Li.new(["two"])
      ])]) }
  end
end
