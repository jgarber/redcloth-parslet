require File.dirname(__FILE__) + '/../spec_helper'

describe "id_filtered_html" do
  examples_from_yaml do |doc|
    RedClothParslet.new(doc['in'], [:filter_ids]).to_html(:sort_attributes)
  end
end
