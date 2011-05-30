describe RedClothParslet::Ast::Attributes do
  
  it "should combine multiple class declarations" do
    described_class.new([{:class=>'class1 class2'}, {:class=>'class3'}]).should == {:class => "class1 class2 class3"}
  end
  
  it "should increment left padding" do
    described_class.new([:padding=>'(']).should == {:style=>{'padding-left'=>1}}
  end
  it "should increment multiple left padding" do
    described_class.new([{:padding=>'('}, {:padding=>'('}]).should == {:style=>{'padding-left'=>2}}
  end
  it "should increment right padding" do
    described_class.new([:padding=>')']).should == {:style=>{'padding-right'=>1}}
  end
  it "should increment padding on both sides" do
    described_class.new([{:padding=>'('}, {:padding=>')'}]).should == {:style=>{'padding-left'=>1,'padding-right'=>1}}
  end
  
  it "should align left" do
    described_class.new([:align=>'<']).should == {:style=>{'text-align'=>'left'}}
  end
  it "should align right" do
    described_class.new([:align=>'>']).should == {:style=>{'text-align'=>'right'}}
  end
  it "should align center" do
    described_class.new([:align=>'=']).should == {:style=>{'text-align'=>'center'}}
  end
  it "should justify" do
    described_class.new([{:align=>'<'}, {:align=>'>'}]).should == {:style=>{'text-align'=>'justify'}}
  end
  
end