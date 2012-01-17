# encoding: UTF-8
require File.join(__FILE__, '../inline/shared_examples_for_simple_inline_elements')

describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  context "plain text" do
    it { should parse("Just plain text.").with(transform).
      as(["Just plain text."]) }
    
    it { should parse("One sentence. Two.").with(transform).
      as(["One sentence. Two."]) }
    
    it { should parse("Roses are red\nViolets are purple").with(transform).
      as(["Roses are red\nViolets are purple"]) }
    
  end

  describe "strong" do
    it_should_behave_like 'a simple inline element', 'strong', '*', RedClothParslet::Ast::Strong

    context "inside em" do
      it { should parse("_No tengo *ningún* idea._").with(transform).
        as([RedClothParslet::Ast::Em.new(["No tengo ", RedClothParslet::Ast::Strong.new(["ningún"]), " idea."])])
      }
    end

    context "inside bold" do
      it { should parse("**I said *go* so do it!**").with(transform).
        as([RedClothParslet::Ast::B.new(["I said ", RedClothParslet::Ast::Strong.new(["go"]), " so do it!"])])
      }
    end
  end

  describe "em" do
    it_should_behave_like 'a simple inline element', 'em', '_', RedClothParslet::Ast::Em

    context "inside strong" do
      it { should parse("*This is _really_ strong!*").with(transform).
        as([RedClothParslet::Ast::Strong.new(["This is ", RedClothParslet::Ast::Em.new(["really"]), " strong!"])])
      }
    end
  end
  
  describe "bold" do
    it { should parse("Could not find **Textile**.").with(transform).
      as(["Could not find ", RedClothParslet::Ast::B.new(["Textile"]), "."])
    }

    it_should_behave_like 'a simple inline element', 'bold', '**', RedClothParslet::Ast::B
  end
  
  describe "italics" do
    it { should parse("I just got the weirdest feeling of __déjà vu__.").with(transform).
      as(["I just got the weirdest feeling of ", RedClothParslet::Ast::I.new(["déjà vu"]), "."])
    }

    it_should_behave_like 'a simple inline element', 'italics', '__', RedClothParslet::Ast::I
  end
  
  context "double-quoted phrase in link" do
    it { should parse(%Q{""Example"":http://example.com}).with(transform).
      as([RedClothParslet::Ast::Link.new([RedClothParslet::Ast::DoubleQuotedPhrase.new(["Example"])], {:href=>"http://example.com"})])
    }
  end

  context "link in double-quoted phrase" do
    it { should parse(%Q{""Example":http://example.com"}).with(transform).
      as([RedClothParslet::Ast::DoubleQuotedPhrase.new([RedClothParslet::Ast::Link.new(["Example"], {:href=>"http://example.com"})])])
    }
  end
  
  describe "span" do
    it_should_behave_like 'a simple inline element', 'span', '%', RedClothParslet::Ast::Span
  end
  
  describe "ins" do
    it_should_behave_like 'a simple inline element', 'ins', '+', RedClothParslet::Ast::Ins
  end
end
