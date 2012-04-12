require File.dirname(__FILE__) + '/../spec_helper'

describe "style_filtered_html" do
  examples_from_yaml do |doc|
    RedClothParslet.new(doc['in'], [:filter_styles]).to_html(:sort_attributes)
  end
end
