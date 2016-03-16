describe RedClothParslet::Parser::Block do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }

  describe "table" do
    it { should parse("|one|two|three|").with(transform).
         as([table([
           table_row([
             table_data(["one"]),
             table_data(["two"]),
             table_data(["three"])
           ])
    ])]) }

    it { should parse("|one|two|three|\n|four|five|six|").with(transform).
         as([table([
           table_row([
             table_data(["one"]),
             table_data(["two"]),
             table_data(["three"])
           ]),
             table_row([
               table_data(["four"]),
               table_data(["five"]),
               table_data(["six"])
           ])
    ])]) }

    it { should parse("|_. Jan|_. Feb|_. Mar|").with(transform).
         as([table([
           table_row([
             table_header(["Jan"]),
             table_header(["Feb"]),
             table_header(["Mar"])
           ])
    ])]) }

    it { should parse("||||\n|a|||").with(transform).
         as([table([
           table_row([table_data([""]), table_data([""]), table_data([""])]),
           table_row([table_data(["a"]), table_data([""]), table_data([""])])
         ])])
    }

    describe "table attributes" do
      it { should parse("table{border:1px solid black}.\n|This|is|a|row|").with(transform).
           as([table([
             table_row([
               table_data(["This"]),
               table_data(["is"]),
               table_data(["a"]),
               table_data(["row"])
             ])
      ], {:style => {"border"=>"1px solid black"}})]) }

      it { should parse("|A|row|\n{background:#ddd}. |Gray|row|").with(transform).
           as([table([
             table_row([
               table_data(["A"]),
               table_data(["row"])
             ]),
               table_row([
                 table_data(["Gray"]),
                 table_data(["row"])
             ], {:style => {"background"=>"#ddd"}})
      ])]) }

      it { should parse("|\\2. spans two cols |").with(transform).
           as([table(
             table_row(
               table_data("spans two cols ", {:colspan => '2'})
             )
      )]) }
      it { should parse("|/2. spans two rows |").with(transform).
           as([table(
             table_row(
               table_data("spans two rows ", {:rowspan => '2'})
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
           as([table([
             table_row([
               table_data([" one "]),
               table_data([" two "]),
               table_data([" three "])
             ])
      ])]) }
    end

    describe "advanced table" do
      it { should parse("|^.\n|_. First Header |_. Second Header |\n|~.\n|\\2=. A footer, centered & across two columns |\n|-.\n| Content Cell | Content Cell |\n| Content Cell | Content Cell |").with(transform).
        as([table([
            t_head([table_row([table_header(["First Header "]), table_header(["Second Header "])])]),
            t_foot([table_row([table_data(["A footer, centered & across two columns "], {:colspan => '2', :style => {"align" => "center"}})])]),
            t_body([
              table_row([table_data([" Content Cell "]), table_data([" Content Cell "])]),
              table_row([table_data([" Content Cell "]), table_data([" Content Cell "])])
            ])
        ])])
      }
    end
  end

end
