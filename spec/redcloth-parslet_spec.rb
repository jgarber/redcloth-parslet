describe RedClothParslet do
  
  it "should convert from Textile to HTML" do
    RedClothParslet.new("And then? She *fell*!").to_html.should == "<p>And then? She <strong>fell</strong>!</p>"
  end
  
end