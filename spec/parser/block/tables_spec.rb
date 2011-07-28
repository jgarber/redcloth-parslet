describe RedClothParslet::Parser::Block do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }
  
  describe "table" do
    it { should parse("|one|two|three|").with(transform).
      as([RedClothParslet::Ast::Table.new([
        RedClothParslet::Ast::TableRow.new([
          RedClothParslet::Ast::TableData.new(["one"]),
          RedClothParslet::Ast::TableData.new(["two"]),
          RedClothParslet::Ast::TableData.new(["three"])
        ])
      ])]) }
  end
  
end