require File.dirname(__FILE__) + '/../spec_helper'

describe "LaTeX" do
  it "should not be included anymore" do
    RedClothParslet.new('no latex').should_not respond_to(:to_latex)
  end

  # examples_from_yaml do |doc|
  #   RedClothParslet.new(doc['in']).to_latex
  # end

  # it "should not raise an error when orphaned parentheses in a link are followed by punctuation and words in LaTeX" do
  #   lambda {
  #     RedClothParslet.new(%Q{Test "(read this":http://test.host), ok}).to_latex
  #   }.should_not raise_error
  # end
end
