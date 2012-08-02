describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }

  describe "em-dash" do
    it "should consume em-dashes" do
      parser.m_dash.should parse('--')
    end

    it { should parse("Observe--very nice!").with(transform).
         as(["Observe", entity("--"), "very nice!"])
    }
    it { should parse("Observe -- very nice!").with(transform).
         as(["Observe ", entity("--"), " very nice!"])
    }
  end

  describe "single hyphens" do
    it { should parse("Twenty-five persimmons!").with(transform).
         as("Twenty-five persimmons!")
    }
    it { should parse("Observe - tiny and brief!").with(transform).
         as(["Observe", entity(" -"), " tiny and brief!"])
    }
  end

  describe "ellipses" do
    it { should parse("She trailed off...").with(transform).
         as(["She trailed off", entity("...")])
    }
  end

  describe "dimensions" do
    context "parser" do
      subject { parser.dimensions }
      it { should parse('4x4')}
      it { should parse('4 x 4')}
      it { should parse('2x4x6')}
      it { should parse('999 x 111')}
      it { should parse('2.5 x 3.14')}
      it { should parse('6,499.99 x 11.1')}
      it { should parse(%Q{5' x 11"})}
      it { should parse(%Q{55" x 1'})}
      it { should parse(%Q{5'8" x 5'11"})}
      it { should parse(%Q{2 3/4" x 1-1/2'})}
      it { should_not parse('2. x 3')}
    end

    it { should parse("Observe: 2x3.").with(transform).
         as(["Observe: 2", entity("x"), "3."])
    }
    it { should parse("The room is 2x3 inches big.").with(transform).
         as(["The room is 2", entity("x"), "3 inches big."])
    }
    it { should parse("Observe: 4 x 3.").with(transform).
         as(["Observe: 4 ", entity("x"), " 3."])
    }
    it { should parse(%Q{The lumber is 1" x 2" x 5'}).with(transform).
         as(['The lumber is ', dimension('1"'), ' ',
             entity("x"), ' ', 
             dimension('2"'), ' ', 
             entity("x"), ' ', 
             dimension("5'")])
    }
    it { should parse(%Q{The lumber is 3/4" x 1-1/2"}).with(transform).
         as(['The lumber is ', dimension('3/4"'), ' ',
             entity("x"), ' ', 
             dimension('1-1/2"')])
    }
    it { should parse(%Q{The lumber is 2 1/4" x 1 1/2"}).with(transform).
         as(['The lumber is ', dimension('2 1/4"'), ' ',
             entity("x"), ' ', 
             dimension('1 1/2"')])
    }
  end

  describe "intellectual property marks" do
    it { should parse("(TM)").with(transform).
         as(entity("(TM)"))
    }
    it { should parse("(R)").with(transform).
         as(entity("(R)"))
    }
    it { should parse("(C)").with(transform).
         as(entity("(C)"))
    }
    it { should parse("(tm)").with(transform).
      as(entity("(tm)"))
    }
    it { should parse("(r)").with(transform).
      as(entity("(r)"))
    }
    it { should parse("(c)").with(transform).
      as(entity("(c)"))
    }
  end

  describe "HTML entities" do
    it { should parse("&pound;").with(transform).
         as(entity("&pound;"))
    }
    it { should parse("&frac12;").with(transform).
         as(entity("&frac12;"))
    }
    it { should parse("&AElig;").with(transform).
         as(entity("&AElig;"))
    }
    it { should parse("&#9731;").with(transform).
         as(entity("&#9731;"))
    }
    it { should parse("&#x2698;").with(transform).
         as(entity("&#x2698;"))
    }
    it { should parse("&#x1f319;").with(transform).
         as(entity("&#x1f319;"))
    }
    it { should parse("&#x1F349;").with(transform).
         as(entity("&#x1F349;"))
    }
  end
end
