# encoding: UTF-8

describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  context "plain text" do
    it { should parse("Just plain text.").with(transform).
      as(["Just plain text."]) }

    it { should parse("One sentence. Two.").with(transform).
      as(["One sentence. Two."]) }
  end
  
  context "em inside strong" do
    it { should parse("*This is _really_ strong!*").with(transform).
      as([RedClothParslet::Ast::Strong.new(["This is ", RedClothParslet::Ast::Em.new(["really"]), " strong!"])])
    }
  end

  context "strong inside em" do
    it { should parse("_No tengo *ningún* idea._").with(transform).
      as([RedClothParslet::Ast::Em.new(["No tengo ", RedClothParslet::Ast::Strong.new(["ningún"]), " idea."])])
    }
  end
  
end
