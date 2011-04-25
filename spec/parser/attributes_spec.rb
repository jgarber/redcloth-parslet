describe RedClothParslet::Parser::Attributes do
  let(:parser) { described_class.new }

  context "style" do
    it { should parse("{color:red;}").
      as([{:style=>"color:red;"}])
    }
  end
  
  context "style + class" do
    it { should parse("{color:red;}(my-class#myid)").
      as([{:style=>"color:red;"}, {:class=>"my-class", :id => "myid"}])
    }
  end
  
  context "class + style" do
    it { should parse("(my-class#myid){color:red;}").
      as([{:class=>"my-class", :id => "myid"}, {:style=>"color:red;"}])
    }
  end  
end
