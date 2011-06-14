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
  
end
