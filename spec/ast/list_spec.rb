describe RedClothParslet::Ast::List do
  let(:empty_attributes) { RedClothParslet::Ast::Attributes.new({}) }
  
  describe ".build" do
    it "should accept hashes to build the AST layout" do
      described_class.build([{:layout => "*", :content => ["uno"], :opts => empty_attributes}]).should == 
        RedClothParslet::Ast::Ul.new(RedClothParslet::Ast::Li.new(["uno"]))
    end
    
    it "should build a multi-level AST from the flat list items" do
      described_class.build([{:layout => "*", :content => ["1"], :opts => empty_attributes},{:layout => "**", :content => ["1.1"], :opts => empty_attributes}]).should == 
        RedClothParslet::Ast::Ul.new([
          RedClothParslet::Ast::Li.new(["1"]),
          RedClothParslet::Ast::Ul.new(RedClothParslet::Ast::Li.new(["1.1"]))
        ])
    end

    it "should build a mixed-list AST" do
      described_class.build([{:layout => "*", :content => ["1"], :opts => empty_attributes},{:layout => "*#", :content => ["1.one"], :opts => empty_attributes}]).should == 
        RedClothParslet::Ast::Ul.new([
          RedClothParslet::Ast::Li.new(["1"]),
          RedClothParslet::Ast::Ol.new(RedClothParslet::Ast::Li.new(["1.one"]))
        ])
    end
  end

end