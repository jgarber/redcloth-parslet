describe RedClothParslet::Formatter::HTML do
  subject { described_class.new(:order_attributes => true).convert(element) }
  
  describe "line breaks" do
    let(:element) { RedClothParslet::Ast::P.new(["Line one\nline two."]) }
    it { should == "<p>Line one<br />\nline two.</p>" }
  end
  
  describe "p" do
    let(:element) { RedClothParslet::Ast::P.new(["My paragraph."]) }
    it { should == "<p>My paragraph.</p>" }
    
    context "containing inline HTML" do
      let(:element) { RedClothParslet::Ast::P.new(RedClothParslet::Ast::HtmlTag.new('<img src="test.jpg" alt="test" />')) }
      it { should == '<p><img src="test.jpg" alt="test" /></p>' }
    end
  end

  describe "bq" do
    let(:element) { RedClothParslet::Ast::Blockquote.new([ RedClothParslet::Ast::P.new(["My paragraph."]) ]) }
    it { should == "<blockquote>\n<p>My paragraph.</p>\n</blockquote>" }
  end

  describe "notextile" do
    let(:element) { RedClothParslet::Ast::Notextile.new(["inside"]) }
    it { should == "inside" }
  end

  describe "div" do
    let(:element) { RedClothParslet::Ast::Div.new(["I am a div"]) }
    it { should == "<div>I am a div</div>" }
  end
  
  describe "pre" do
    let(:element) { RedClothParslet::Ast::Pre.new(["Preformatted -> nice!\n\nTwice as nice!"]) }
    it { should == "<pre>Preformatted -&gt; nice!\n\nTwice as nice!</pre>" }
  end
  
  describe "pre_tag" do
    let(:element) { RedClothParslet::Ast::Pre.new("\nThe bold tag is <b>\n", :open_tag => '<pre>') }
    it { should == "<pre>\nThe bold tag is &lt;b&gt;\n</pre>" }
  end
  
  describe "horizontal rule" do
    let(:element) { RedClothParslet::Ast::Hr.new() }
    it { should == "<hr />" }
  end
  
  describe "ul" do
    let(:element) { RedClothParslet::Ast::Ul.new([
      RedClothParslet::Ast::Li.new(["1"]), 
      RedClothParslet::Ast::Ul.new(RedClothParslet::Ast::Li.new(["1.1"])),
      RedClothParslet::Ast::Li.new(["2"])
    ]) }
    it { should == <<-END.gsub(/^ +/, '').chomp
      <ul>
      	<li>1
      	<ul>
      		<li>1.1</li>
      	</ul></li>
      	<li>2</li>
      </ul>
    END
    }
  end
  
  describe "ol" do
    let(:element) { RedClothParslet::Ast::Ol.new([
      RedClothParslet::Ast::Li.new(["one"]), 
      RedClothParslet::Ast::Ol.new(RedClothParslet::Ast::Li.new(["one-one"])),
      RedClothParslet::Ast::Li.new(["two"])
    ]) }
    it { should == <<-END.gsub(/^ +/, '').chomp
      <ol>
      	<li>one
      	<ol>
      		<li>one-one</li>
      	</ol></li>
      	<li>two</li>
      </ol>
    END
    }
  end
  
  describe "table" do
    let(:element) { RedClothParslet::Ast::Table.new([
      RedClothParslet::Ast::TableRow.new([
        RedClothParslet::Ast::TableHeader.new(["one"]),
        RedClothParslet::Ast::TableHeader.new(["two"]),
        RedClothParslet::Ast::TableHeader.new(["three"])
      ]),
      RedClothParslet::Ast::TableRow.new([
        RedClothParslet::Ast::TableData.new(["1"]),
        RedClothParslet::Ast::TableData.new(["2"]),
        RedClothParslet::Ast::TableData.new(["3"])
      ])
    ]) }
    
    it { should == "<table><tr><th>one</th><th>two</th><th>three</th></tr><tr><td>1</td><td>2</td><td>3</td></tr></table>" }
  end
end
