describe RedClothParslet::Parser::PreTag do
  describe "tag" do
    it { should parse("<pre></pre>") }
    it { should parse("<pre>\n<br />\n</pre>") }
    it { should parse("<pre class='foo'>\nA pre block with attributes\n</pre>") }
    it { should parse("<pre>\nA pre block\n\nstill going\n</pre>") }
  end
end
