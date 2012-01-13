require 'ast/shared_examples_for_simple_nodes'

describe RedClothParslet::Ast::Dimension do
  it_behaves_like "a simple node" do
    let(:string) { %q[5'10"] }
  end
end
