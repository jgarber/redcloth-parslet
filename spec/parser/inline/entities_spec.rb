describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "em-dash" do
    it "should consume em-dashes" do
      parser.m_dash.should parse('--')
    end
    
    it { should parse("Observe--very nice!").with(transform).
      as(["Observe", RedClothParslet::Ast::Entity.new("--"), "very nice!"])
    }
    it { should parse("Observe -- very nice!").with(transform).
      as(["Observe ", RedClothParslet::Ast::Entity.new("--"), " very nice!"])
    }
  end
  
  describe "single hyphens" do
    it { should parse("Twenty-five persimmons!").with(transform).
      as(["Twenty-five persimmons!"])
    }
    it { should parse("Observe - tiny and brief!").with(transform).
      as(["Observe", RedClothParslet::Ast::Entity.new(" -"), " tiny and brief!"])
    }
  end

  describe "ellipses" do
    it { should parse("She trailed off...").with(transform).
      as(["She trailed off", RedClothParslet::Ast::Entity.new("...")])
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
      as(["Observe: 2", RedClothParslet::Ast::Entity.new("x"), "3."])
    }
    it { should parse("The room is 2x3 inches big.").with(transform).
      as(["The room is 2", RedClothParslet::Ast::Entity.new("x"), "3 inches big."])
    }
    it { should parse("Observe: 4 x 3.").with(transform).
      as(["Observe: 4 ", RedClothParslet::Ast::Entity.new("x"), " 3."])
    }
    it { should parse(%Q{The lumber is 1" x 2" x 5'}).with(transform).
      as(['The lumber is ', RedClothParslet::Ast::Dimension.new('1"'), ' ',
          RedClothParslet::Ast::Entity.new("x"), ' ', 
          RedClothParslet::Ast::Dimension.new('2"'), ' ', 
          RedClothParslet::Ast::Entity.new("x"), ' ', 
          RedClothParslet::Ast::Dimension.new("5'")])
    }
    it { should parse(%Q{The lumber is 3/4" x 1-1/2"}).with(transform).
      as(['The lumber is ', RedClothParslet::Ast::Dimension.new('3/4"'), ' ',
          RedClothParslet::Ast::Entity.new("x"), ' ', 
          RedClothParslet::Ast::Dimension.new('1-1/2"')])
    }
    it { should parse(%Q{The lumber is 2 1/4" x 1 1/2"}).with(transform).
      as(['The lumber is ', RedClothParslet::Ast::Dimension.new('2 1/4"'), ' ',
          RedClothParslet::Ast::Entity.new("x"), ' ', 
          RedClothParslet::Ast::Dimension.new('1 1/2"')])
    }
  end
  
  describe "intellectual property marks" do
    it { should parse("(TM)").with(transform).
      as([RedClothParslet::Ast::Entity.new("(TM)")])
    }
    it { should parse("(R)").with(transform).
      as([RedClothParslet::Ast::Entity.new("(R)")])
    }
    it { should parse("(C)").with(transform).
      as([RedClothParslet::Ast::Entity.new("(C)")])
    }
    it { should parse("(tm)").with(transform).
      as([RedClothParslet::Ast::Entity.new("(tm)")])
    }
    it { should parse("(r)").with(transform).
      as([RedClothParslet::Ast::Entity.new("(r)")])
    }
    it { should parse("(c)").with(transform).
      as([RedClothParslet::Ast::Entity.new("(c)")])
    }
  end
  
end
