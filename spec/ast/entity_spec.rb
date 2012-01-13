require 'ast/shared_examples_for_simple_nodes'

describe RedClothParslet::Ast::Entity do
  it_behaves_like "a simple node" do
    let(:string) { %q["] }
  end
end
