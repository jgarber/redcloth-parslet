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
      
    it { should parse("|one|two|three|\n|four|five|six|").with(transform).
      as([RedClothParslet::Ast::Table.new([
        RedClothParslet::Ast::TableRow.new([
          RedClothParslet::Ast::TableData.new(["one"]),
          RedClothParslet::Ast::TableData.new(["two"]),
          RedClothParslet::Ast::TableData.new(["three"])
        ]),
        RedClothParslet::Ast::TableRow.new([
          RedClothParslet::Ast::TableData.new(["four"]),
          RedClothParslet::Ast::TableData.new(["five"]),
          RedClothParslet::Ast::TableData.new(["six"])
        ])
      ])]) }
  end
  
end