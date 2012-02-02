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

  describe "unfinished quote paragraph" do
    let(:element) { RedClothParslet::Ast::P.new(%Q{"This is part of a multi-paragraph quote}, :possible_unfinished_quote_paragraph => true) }
    it { should == "<p>&#8220;This is part of a multi-paragraph quote</p>" }
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

  describe "blockcode" do
    let(:element) { RedClothParslet::Ast::Blockcode.new("def leopard()\n\tpurr\nend") }
    it { should == "<pre><code>def leopard()\n\tpurr\nend\n</code></pre>" }
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

    it { should == <<-END.gsub(/^ +/, '').chomp
      <table>
      \t<tr>
      \t\t<th>one</th>
      \t\t<th>two</th>
      \t\t<th>three</th>
      \t</tr>
      \t<tr>
      \t\t<td>1</td>
      \t\t<td>2</td>
      \t\t<td>3</td>
      \t</tr>
      </table>
    END
    }
  end

  describe "footnote" do
    let(:element) { RedClothParslet::Ast::Footnote.new("A footnote", :number => "1") }
    it { should == '<p class="footnote" id="fn1"><a href="#fnr1"><sup>1</sup></a> A footnote</p>' }
  end

end
