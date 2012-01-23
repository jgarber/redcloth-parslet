describe RedClothParslet::Parser::HtmlTag do
  describe "tag" do
    it { should parse("<div>") }
    it { should parse("<hr />") }
    it { should parse("<script/>") }
    it { should parse("<div attr='val'>") }
    it { should parse("<br class='clear' />") }
    it { should parse("<div selected>") }
    it { should parse("</div>") }
  end
  
  describe "attribute" do
    let(:parser) { described_class.new.attribute }
    subject { described_class.new.attribute }
    
    it { should parse(" class=''") }    
    it { should parse(' class=""') }
    it { should parse(" class='awesome'") }    
    it { should parse(' class="rad"') }

    it { should_not parse(' 9kittens="cute"') }
    
  end
end
