describe RedClothParslet do
  
  it "should convert from Textile to HTML" do
    RedClothParslet.new("And then? She *fell*!").to_html.should == "<p>And then? She <strong>fell</strong>!</p>"
  end
  
  describe "rules" do
    it "should sort attributes alphabetically" do
      input = "p((class){color:red}. Test"
      class_attr = ' class="class"'
      style_attr = ' style="color:red;padding-left:1em;"'
      sorted_output = RedClothParslet.new(input).to_html(:sort_attributes)
      sorted_output.should == "<p#{class_attr}#{style_attr}>Test</p>"
    end
  end
end
