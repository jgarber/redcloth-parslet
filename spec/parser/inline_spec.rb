# encoding: UTF-8
require File.join(File.dirname(__FILE__), 'inline/shared_examples_for_simple_inline_elements')

describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }

  context "plain text" do
    it { should parse("Just plain text.").with(transform).
         as("Just plain text.") }

    it { should parse("One sentence. Two.").with(transform).
         as("One sentence. Two.") }

    it { should parse("Roses are red\nViolets are purple").with(transform).
         as("Roses are red\nViolets are purple") }

  end

  describe "strong" do
    it_should_behave_like 'a simple inline element', 'strong', '*', RedClothParslet::Ast::Strong

    context "inside em" do
      it { should parse("_No tengo *ningún* idea._").with(transform).
           as([em("No tengo ", strong("ningún"), " idea.")])
      }
    end

    context "inside bold" do
      it { should parse("**I said *go* so do it!**").with(transform).
           as([b("I said ", strong("go"), " so do it!")])
      }
    end
  end

  describe "em" do
    it_should_behave_like 'a simple inline element', 'em', '_', RedClothParslet::Ast::Em

    context "inside strong" do
      it { should parse("*This is _really_ strong!*").with(transform).
           as([strong("This is ", em("really"), " strong!")])
      }
    end

    context "in square brackets" do
      it { should parse("Puh[_leeeze_]!").with(transform).
           as(["Puh", em("leeeze"), "!"])
      }
    end
  end

  describe "bold" do
    it { should parse("Could not find **Textile**.").with(transform).
         as(["Could not find ", b("Textile"), "."])
    }

    it_should_behave_like 'a simple inline element', 'b', '**', RedClothParslet::Ast::B
  end

  describe "italics" do
    it { should parse("I just got the weirdest feeling of __déjà vu__.").with(transform).
         as(["I just got the weirdest feeling of ", i("déjà vu"), "."])
    }

    it_should_behave_like 'a simple inline element', 'i', '__', RedClothParslet::Ast::I
  end

  it { should parse("__Amanita__s are mushrooms.\nLungworts (__Lobaria__) are lichens.") }

  context "double-quoted phrase in link" do
    it { should parse(%Q{""Example"":http://example.com}).with(transform).
         as(link(double_quoted_phrase("Example"), {:href=>"http://example.com"}))
    }

    it { should parse(%Q{"a "short" example":http://example.com}).with(transform).
         as(link(["a ", double_quoted_phrase("short"), " example"], {:href=>"http://example.com"}))
    }
  end

  context "link in double-quoted phrase" do
    it { should parse(%Q{""Example":http://example.com"}).with(transform).
         as(double_quoted_phrase(link("Example", {:href=>"http://example.com"})))
    }

    it { should parse(%Q{"a "little":http://example.com example"}).with(transform).
         as(double_quoted_phrase(["a ", link("little", {:href=>"http://example.com"}), " example"]))
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
         as(del("del phrase")) }

    it "should allow a del phrase at the end of a sentence before punctuation" do
      subject.should parse("Is she a Schwarzenegger -still-?").with(transform).
        as(["Is she a Schwarzenegger ", del("still"),  "?"])
    end

    it "should parse a deleted phrase containing hyphenated words" do
      subject.should parse("The -widow-maker- is a time-honored tradition.").with(transform).
        as(["The ", del("widow-maker"), " is a time-honored tradition."])
    end
  end

  describe "cite" do
    it { should parse("??A Tale of Two Cities??").with(transform).
         as(cite("A Tale of Two Cities")) }
    it { should parse("??What's up???").with(transform).
         as(cite("What's up?")) }
  end

  describe "caps" do
    it { should parse("I got a PDQ job with NASA in the US.").with(transform).
         as(["I got a ", caps("PDQ"), " job with ", caps("NASA"), " in the US."])
    }
    it { should parse("(USA)").with(transform).
         as(["(", caps("USA"), ")"])
    }
    it { should parse("EOLs").with(transform).as([caps('EOL'), 's']) }
    it { should parse("LOLCamelCase").with(transform).as("LOLCamelCase") }
  end

  describe 'subscript' do
    it_should_behave_like 'a simple inline element', 'sub', '~', RedClothParslet::Ast::Sub
  end

  describe 'superscript' do
    it_should_behave_like 'a simple inline element', 'sup', '^', RedClothParslet::Ast::Sup
  end

  describe "footnote reference" do
    it { should parse("I refer you to the footnote[1]").with(transform).
         as(["I refer you to the footnote", footnote_reference("1")]) }
  end

  describe "inline HTML" do
    it { should parse("Fluffy <img src='bunnies' />.").with(transform).
         as(["Fluffy ", html_tag("<img src='bunnies' />"), "."]) }
    it { should parse("I am <b>very</b> serious.").with(transform).
         as(["I am ", html_tag("<b>"), "very", html_tag("</b>"), " serious."]) }
  end
end
