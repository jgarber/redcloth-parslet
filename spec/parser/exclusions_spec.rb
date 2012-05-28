describe "Exclusions Parslet extension" do

  class NestedBrackets < Parslet::Parser
    root(:document)

    rule(:document) { entity.repeat }
    rule(:entity)  { 
      parentheses.unless_excluded(:parentheses) |
      square_brackets.unless_excluded(:square_brackets) |
      other
    }
    rule(:parentheses) do
      str('(').as(:bracket) >> 
      document.exclude(:parentheses).as(:c) >> 
      str(')')
    end
    rule(:square_brackets) do
      str('[').as(:bracket) >> 
      document.exclude(:square_brackets).as(:c) >> 
      str(']')
    end
    rule(:other) do
      (
        str(')').absent?.if_excluded(:parentheses) >> 
        str(']').absent?.if_excluded(:square_brackets) >> 
        any
      ).as(:s)
    end
  end
  class NestedBracketsTransform < Parslet::Transform
    rule(:s => simple(:s)) { String(s) }
  end

  let(:parser) { NestedBrackets.new }
  let(:transform) { NestedBracketsTransform.new }

  it "should parse a complex set of nested brackets using an exclude stack" do
    parser.should parse(")((A [B])[C (D)] [E").with(transform).as(
      [")", 
       {:bracket=>"(", :c=>[
         "(A ", 
         {:bracket=>"[", :c=>[
           "B"]}]}, 
           {:bracket=>"[", :c=>[
             "C ", 
             {:bracket=>"(", :c=>[
               "D"]}]}, 
               " [E"]
    )
  end

  class ZeroParser < Parslet::Parser
    rule(:zero) { str('0').unless_excluded(:zero) }
    root(:zero)
  end

  it "should raise an error when parse fails due to an exclusion" do
    expect {
      ZeroParser.new.exclude(:zero).parse("0")
    }.to raise_error(Parslet::ParseFailed, "zero is excluded in this context at line 1 char 1.")
  end
end
