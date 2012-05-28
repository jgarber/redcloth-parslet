require File.join(File.dirname(__FILE__), 'shared_examples_for_simple_inline_elements')

describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  let(:transform) { RedClothParslet::Transform.new }

  describe "code" do
    it_should_behave_like 'a simple inline element', 'code', '@', RedClothParslet::Ast::Code

    it { should parse(%Q{@code *yeah* code@}).with(transform).
         as(code("code *yeah* code"))
    }
  end

  describe "code tag" do
    it { should parse(%Q{<code>code *yeah* code</code>}).with(transform).
         as(code("code *yeah* code"))
    }
  end
end
