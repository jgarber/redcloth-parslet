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
  
  describe "#new" do
    it "should accept a single nested element for content" do
      nested_item = described_class.new('content')
      nested_item.children.should == ['content']
      described_class.new(nested_item).children.should == [nested_item]    
    end

    it "should accept multiple nested elements as arguments" do
      nested_item_1 = described_class.new('content')
      nested_item_2 = nested_item_1.clone
      described_class.new(nested_item_1, nested_item_2).children.should == [nested_item_1, nested_item_2]    
    end

    it "should accept multiple nested elements plus options as arguments" do
      nested_item = described_class.new('content')
      described_class.new(nested_item, nested_item, {:class=>'myclass'}).opts.should == {:class=>'myclass'}
    end
    
    it "should accept options as an argument" do
      described_class.new(:class=>'myclass').opts.should == {:class=>'myclass'}
    end
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
  
  describe "#inspect" do
    its(:inspect) { should == %Q{#<RedClothParslet::Ast::Element opts:{:class=>"myclass"} children:["content"]>} }
    
    context "when no element attributes" do
      subject { described_class.new(['content']) }
      its(:inspect) { should == %Q{#<RedClothParslet::Ast::Element children:["content"]>} }
    end
    
    context "when no children" do
      subject { described_class.new({:class=>"myclass"}) }
      its(:inspect) { should == %Q{#<RedClothParslet::Ast::Element opts:{:class=>"myclass"}>} }
    end
  end
  
end
