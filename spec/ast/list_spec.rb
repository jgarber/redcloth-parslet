describe RedClothParslet::Ast::List do
  
  describe ".build" do
    context "single-level list" do
      it "should accept hashes to build the AST layout" do
        described_class.build([{:layout => "*", :content => ["uno"]}]).should == 
          RedClothParslet::Ast::Ul.new(RedClothParslet::Ast::Li.new(["uno"]))
      end
    end
    
    it "should build a multi-level AST from the flat list items" do
      described_class.build([{:layout => "*", :content => ["1"]},{:layout => "**", :content => ["1.1"]}]).should == 
        RedClothParslet::Ast::Ul.new([
          RedClothParslet::Ast::Li.new(["1"]),
          RedClothParslet::Ast::Ul.new(RedClothParslet::Ast::Li.new(["1.1"]))
        ])
    end

    it "should build a mixed-list AST" do
      described_class.build([{:layout => "*", :content => ["1"]},{:layout => "*#", :content => ["1.one"]}]).should == 
        RedClothParslet::Ast::Ul.new([
          RedClothParslet::Ast::Li.new(["1"]),
          RedClothParslet::Ast::Ol.new(RedClothParslet::Ast::Li.new(["1.one"]))
        ])
    end
  end

end