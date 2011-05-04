describe RedClothParslet::Transform::Inline do
  let(:transform) { described_class.new(Nokogiri::HTML::Document.new) }
  subject { transform.apply(tree).to_html }
    
  describe "plain text" do
    let(:tree) { {:s => "Plain text"} }
    it { should == "Plain text" }
  end
  
  describe "strong" do
    let(:tree) { {:inline=>"*", :content=>[{:s=>"inside"}], :attributes=>[]} }
    it { should == "<strong>inside</strong>" }
  end

  describe "em" do
    let(:tree) { {:inline=>"_", :content=>[{:s=>"inside"}], :attributes=>[]} }
    it { should == "<em>inside</em>" }
  end
  
  describe "em inside strong" do
    let(:tree) { {:inline=>"*", :content=>[{:inline=>"_", :content=>[{:s=>"inside"}], :attributes=>[]}], :attributes=>[]} }
    it { should == "<strong><em>inside</em></strong>" }
  end
  
  describe "attributes" do
    describe "class" do
      let(:tree) { {:inline=>"*", :content=>[{:s=>"inside"}], :attributes=>[{:class=>'myclass'}]} }
      it { should == %{<strong class="myclass">inside</strong>} }
    end
    
    describe "class + id" do
      let(:tree) { {:inline=>"*", :content=>[{:s=>"inside"}], :attributes=>[{:class=>'myclass'}, {:id=>'my-id'}]} }
      it { should == %{<strong class="myclass" id="my-id">inside</strong>} }
    end
    
    describe "(class + class) + class" do
      let(:tree) { {:inline=>"*", :content=>[{:s=>"inside"}], :attributes=>[{:class=>'class1 class2'}, {:class=>'class3'}]} }
      it { should == %{<strong class="class1 class2 class3">inside</strong>} }
    end
    
    describe "multiple padding" do
      pending # WIP on making a helper method that can handle multiple padding
      let(:tree) { {:inline=>"*", :content=>[{:s=>"inside"}], :attributes=>[{:padding=>'('},{:padding=>'('}]} }
      it { should == %{<strong class="myclass">inside</strong>} }
    end
  end

end