describe RedClothParslet::Ast::Element do
  
  subject { described_class.new(['content'], {:class=>'myclass'}) }
  
  it { should respond_to(:contained_elements) }
  it { should respond_to(:opts) }
  
  it "should store the element's contents" do
    subject.contained_elements.should == ['content']
  end
  
  it "should store the element's attributes" do
    subject.opts.should == {:class=>'myclass'}
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
