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
  
    it { should parse("|_. Jan|_. Feb|_. Mar|").with(transform).
      as([RedClothParslet::Ast::Table.new([
        RedClothParslet::Ast::TableRow.new([
          RedClothParslet::Ast::TableHeader.new(["Jan"]),
          RedClothParslet::Ast::TableHeader.new(["Feb"]),
          RedClothParslet::Ast::TableHeader.new(["Mar"])
        ])
      ])]) }
      
    it { should parse("table{border:1px solid black}.\n|This|is|a|row|").with(transform).
      as([RedClothParslet::Ast::Table.new([
        RedClothParslet::Ast::TableRow.new([
          RedClothParslet::Ast::TableData.new(["This"]),
          RedClothParslet::Ast::TableData.new(["is"]),
          RedClothParslet::Ast::TableData.new(["a"]),
          RedClothParslet::Ast::TableData.new(["row"])
        ])
      ], {:style => "border:1px solid black"})]) }
  end
  
end