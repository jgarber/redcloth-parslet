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
      
    describe "table attributes" do
      it { should parse("table{border:1px solid black}.\n|This|is|a|row|").with(transform).
        as([RedClothParslet::Ast::Table.new([
          RedClothParslet::Ast::TableRow.new([
            RedClothParslet::Ast::TableData.new(["This"]),
            RedClothParslet::Ast::TableData.new(["is"]),
            RedClothParslet::Ast::TableData.new(["a"]),
            RedClothParslet::Ast::TableData.new(["row"])
          ])
        ], {:style => {"border"=>"1px solid black"}})]) }
        
      it { should parse("|A|row|\n{background:#ddd}. |Gray|row|").with(transform).
        as([RedClothParslet::Ast::Table.new([
          RedClothParslet::Ast::TableRow.new([
            RedClothParslet::Ast::TableData.new(["A"]),
            RedClothParslet::Ast::TableData.new(["row"])
          ]),
          RedClothParslet::Ast::TableRow.new([
            RedClothParslet::Ast::TableData.new(["Gray"]),
            RedClothParslet::Ast::TableData.new(["row"])
          ], {:style => {"background"=>"#ddd"}})
        ])]) }
      
      it { should parse("|\\2. spans two cols |").with(transform).
        as([RedClothParslet::Ast::Table.new(
          RedClothParslet::Ast::TableRow.new(
            RedClothParslet::Ast::TableData.new("spans two cols ", {:colspan => '2'})
          )
        )]) }
      it { should parse("|/2. spans two rows |").with(transform).
        as([RedClothParslet::Ast::Table.new(
          RedClothParslet::Ast::TableRow.new(
            RedClothParslet::Ast::TableData.new("spans two rows ", {:rowspan => '2'})
          )
        )]) }
    end
    
    describe "table row" do
      subject { described_class.new.table_row }
      it { should parse("|one|two|") } 
      it { should parse("{color:red}. |one|two|") }
    end

    describe "end_table_row" do
      subject { described_class.new.end_table_row }
    end

    context "spaces around table data" do
      it { should parse("| one | two | three |").with(transform).
        as([RedClothParslet::Ast::Table.new([
          RedClothParslet::Ast::TableRow.new([
            RedClothParslet::Ast::TableData.new([" one "]),
            RedClothParslet::Ast::TableData.new([" two "]),
            RedClothParslet::Ast::TableData.new([" three "])
          ])
        ])]) }
    end
  end
  
end
