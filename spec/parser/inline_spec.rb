# encoding: UTF-8
require File.join(File.dirname(__FILE__), 'inline/shared_examples_for_simple_inline_elements')

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

    context "in square brackets" do
      it { should parse("Puh[_leeeze_]!").with(transform).
        as(["Puh", RedClothParslet::Ast::Em.new(["leeeze"]), "!"])
      }
    end
  end
  
  describe "bold" do
    it { should parse("Could not find **Textile**.").with(transform).
      as(["Could not find ", RedClothParslet::Ast::B.new(["Textile"]), "."])
    }

    it_should_behave_like 'a simple inline element', 'b', '**', RedClothParslet::Ast::B
  end
  
  describe "italics" do
    it { should parse("I just got the weirdest feeling of __déjà vu__.").with(transform).
      as(["I just got the weirdest feeling of ", RedClothParslet::Ast::I.new(["déjà vu"]), "."])
    }

    it_should_behave_like 'a simple inline element', 'i', '__', RedClothParslet::Ast::I
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

  describe "del" do
    it { should parse("-del phrase-").with(transform).
      as([RedClothParslet::Ast::Del.new(["del phrase"])]) }
    
    it "should allow a del phrase at the end of a sentence before punctuation" do
      subject.should parse("Is she a Schwarzenegger -still-?").with(transform).
        as(["Is she a Schwarzenegger ", RedClothParslet::Ast::Del.new(["still"]),  "?"])
    end

    it "should parse a deleted phrase containing hyphenated words" do
      subject.should parse("The -widow-maker- is a time-honored tradition.").with(transform).
        as(["The ", RedClothParslet::Ast::Del.new(["widow-maker"]), " is a time-honored tradition."])
    end
  end
  
  describe "cite" do
    it { should parse("??A Tale of Two Cities??").with(transform).
      as([RedClothParslet::Ast::Cite.new("A Tale of Two Cities")]) }
    it { should parse("??What's up???").with(transform).
      as([RedClothParslet::Ast::Cite.new("What's up?")]) }
  end

  describe "caps" do
    it { should parse("I got a PDQ job with NASA in the US.").with(transform).
      as(["I got a ", RedClothParslet::Ast::Caps.new("PDQ"), " job with ", RedClothParslet::Ast::Caps.new("NASA"), " in the US."])
    }
  end

  describe 'subscript' do
    it_should_behave_like 'a simple inline element', 'sub', '~', RedClothParslet::Ast::Sub
  end

  describe 'superscript' do
    it_should_behave_like 'a simple inline element', 'sup', '^', RedClothParslet::Ast::Sup
  end
  
  describe "footnote reference" do
    it { should parse("I refer you to the footnote[1]").with(transform).
      as(["I refer you to the footnote", RedClothParslet::Ast::FootnoteReference.new("1")]) }
  end
  
  describe "inline HTML" do
    it { should parse("Fluffy <img src='bunnies' />.").with(transform).
      as(["Fluffy ", RedClothParslet::Ast::HtmlTag.new("<img src='bunnies' />"), "."]) }
    it { should parse("I am <b>very</b> serious.").with(transform).
      as(["I am ", RedClothParslet::Ast::HtmlTag.new("<b>"), "very", RedClothParslet::Ast::HtmlTag.new("</b>"), " serious."]) }
  end
end
