describe RedClothParslet::Parser::Attributes do
  let(:parser) { described_class.new }
  
  it { should parse("(myclass)").as([{:class=>"myclass"}]) }
  it { should parse("(class-one class-two)").as([{:class=>"class-one class-two"}])}
  it { should parse("(#my-id)").as([{:id=>"my-id"}]) }
  it { should parse("(my-class#myid)").as([{:class=>"my-class", :id => "myid"}]) }
  it { should parse("(one-class another-class#myid)").as([{:class=>"one-class another-class", :id => "myid"}]) }
  
  
  it { should parse("(my-class)") }
  it { should parse("(my_class)") }
  it { should parse("(my-class-7)") }
  it { should parse("(q99)") }
  it { should parse("(c)") }
  
  it { should parse("(#my-id)") }
  it { should parse("(#my_id)") }
  it { should parse("(#my-id-9)") }
  it { should parse("(#a44)") }
  it { should parse("(#b)") }
  
  ## Textile 2.2 doesn't care about invalid classes and IDs, so neither
  ## will we for now.
  # it { should_not parse("(#my.class)") }
  # it { should_not parse("(#9myclass)") }
  # it { should_not parse("(#-myclass)") }
  # it { should_not parse("(#my id)") }
  # it { should_not parse("(#my.id)") }
  # it { should_not parse("(#9myid)") }
  # it { should_not parse("(#-myid)") }
  
end
