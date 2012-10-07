describe RedClothParslet::Formatter::HTML do
  subject { described_class.new(:sort_attributes => true).convert(element) }

  describe "line breaks" do
    let(:element) { p(["Line one\nline two."]) }
    it { should == "<p>Line one<br />\nline two.</p>" }
  end

  describe "p" do
    let(:element) { p(["My paragraph."]) }
    it { should == "<p>My paragraph.</p>" }

    context "containing inline HTML" do
      let(:element) { p(html_tag('<img src="test.jpg" alt="test" />')) }
      it { should == '<p><img src="test.jpg" alt="test" /></p>' }
    end
  end

  describe "bq" do
    let(:element) { blockquote([ p(["My paragraph."]) ]) }
    it { should == "<blockquote>\n<p>My paragraph.</p>\n</blockquote>" }
  end

  describe "unfinished quote paragraph" do
    let(:element) { p(%Q{"This is part of a multi-paragraph quote}, :possible_unfinished_quote_paragraph => true) }
    it { should == "<p>&#8220;This is part of a multi-paragraph quote</p>" }
  end

  describe "notextile" do
    let(:element) { notextile(["inside"]) }
    it { should == "inside" }
  end

  describe "div" do
    let(:element) { div(["I am a div"]) }
    it { should == "<div>I am a div</div>" }
  end

  describe "pre" do
    let(:element) { pre(["Preformatted -> nice!\n\nTwice as nice!"]) }
    it { should == "<pre>Preformatted -&gt; nice!\n\nTwice as nice!</pre>" }
  end

  describe "pre_tag" do
    let(:element) { pre("\nThe bold tag is <b>\n", :open_tag => '<pre>') }
    it { should == "<pre>\nThe bold tag is &lt;b&gt;\n</pre>" }
  end
  describe "code_tag" do
    let(:element) { code("\nThe bold tag is <b>\n", :open_tag => '<code>') }
    it { should == "<code>\nThe bold tag is &lt;b&gt;\n</code>" }
  end
  
  describe "blockcode" do
    let(:element) { blockcode("def leopard()\n\tpurr\nend") }
    it { should == "<pre><code>def leopard()\n\tpurr\nend</code></pre>" }
  end

  describe "hard break" do
    let(:element) { br() }
    it { should == "<br />" }
  end

  describe "horizontal rule" do
    let(:element) { hr() }
    it { should == "<hr />" }
  end

  describe "ul" do
    let(:element) { ul([
      li(["1"]),
      ul(li(["1.1"])),
      li(["2"])
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
    let(:element) { ol([
      li(["one"]),
      ol(li(["one-one"])),
      li(["two"])
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

  describe "dl" do
    let(:element) { dl([
      dt(["tact"]),
      dd(["the ability to close your mouth before someone else wants to"])
    ]) }
    it { should == <<-END.gsub(/^ +/, '').chomp
      <dl>
      	<dt>tact</dt>
      	<dd>the ability to close your mouth before someone else wants to</dd>
      </dl>
    END
    }
  end

  describe "table" do
    let(:element) { table([
      table_row([
        table_header(["one"]),
        table_header(["two"]),
        table_header(["three"])
      ]),
      table_row([
        table_data(["1"]),
        table_data(["2"]),
        table_data(["3"])
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
    let(:element) { footnote("A footnote", :number => "1") }
    it { should == '<p class="footnote" id="fn1"><a href="#fnr1"><sup>1</sup></a> A footnote</p>' }
  end

end
