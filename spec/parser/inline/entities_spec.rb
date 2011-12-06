describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "em-dash" do
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
  
end
