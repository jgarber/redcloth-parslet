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
    described_class.new([:align=>'<']).should == {:style=>{'align'=>'left'}}
  end
  it "should align right" do
    described_class.new([:align=>'>']).should == {:style=>{'align'=>'right'}}
  end
  it "should align center" do
    described_class.new([:align=>'=']).should == {:style=>{'align'=>'center'}}
  end
  it "should justify" do
    described_class.new([{:align=>'<'}, {:align=>'>'}]).should == {:style=>{'align'=>'justify'}}
  end

  it "should vertical-align top" do
    described_class.new([:vertical_align=>'^']).should == {:style=>{'vertical-align'=>'top'}}
  end
  it "should vertical-align middle" do
    described_class.new([:vertical_align=>'-']).should == {:style=>{'vertical-align'=>'middle'}}
  end
  it "should vertical-align bottom" do
    described_class.new([:vertical_align=>'~']).should == {:style=>{'vertical-align'=>'bottom'}}
  end
  
  it "should pass through other styles" do
    described_class.new([{:style=>'color:red'}]).should == {:style=>{'color'=>'red'}}
  end
  it "should combine passed-through style and padding" do
    described_class.new([{:padding=>'('}, {:style=>'color:red'}]).should == {:style=>{'padding-left'=>1, 'color'=>'red'}}
  end
  it "should combine multiple styles" do
    described_class.new([{:style=>'color:red'},{:style=>'margin:1px'}]).should == {:style=>{'color'=>'red', 'margin'=>'1px'}}
  end
  it "should combine multiple styles in one declaration" do
    described_class.new([{:style=>'color:red;margin:1px'}]).should == {:style=>{'color'=>'red', 'margin'=>'1px'}}
  end
  it "should overwrite duplicate styles" do
    described_class.new([{:style=>'color:red'},{:style=>'color:blue;'}]).should == {:style=>{'color'=>'blue'}}
  end
  
end