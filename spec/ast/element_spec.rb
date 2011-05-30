describe RedClothParslet::Ast::Element do
  
  subject { described_class.new(['content'], {:class=>'myclass'}) }
  
  it { should respond_to(:children) }
  it { should respond_to(:opts) }
  
  it "should store the element's contents" do
    subject.children.should == ['content']
  end
  
  it "should store the element's attributes" do
    subject.opts.should == {:class=>'myclass'}
  end
  
  it "should report the element's type" do
    class RedClothParslet::Ast::FooBar < RedClothParslet::Ast::Element; end
    RedClothParslet::Ast::FooBar.new.type.should == :foo_bar
  end
  
  it "should be equal when its contents and attributes are equal" do
    subject.should == RedClothParslet::Ast::Element.new(['content'], {:class=>'myclass'})
  end
  
  it "should not be equal to an element of a different type" do
    class RedClothParslet::Ast::Element2 < RedClothParslet::Ast::Element; end
    subject.should_not == RedClothParslet::Ast::Element2.new(['content'], {:class=>'myclass'})
  end
  
  it "should not be equal when content differs" do
    subject.should_not == RedClothParslet::Ast::Element.new(['foo'], {:class=>'myclass'})
  end
  
  it "should not be equal when attributes differ" do
    subject.should_not == RedClothParslet::Ast::Element.new(['content'], {:class=>'myclass', :id=>'el'})
  end
  
end
