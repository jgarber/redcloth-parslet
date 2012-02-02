describe RedClothParslet::Parser::Attributes do
  let(:parser) { described_class.new }
  
  it { should parse("<").as([:align=>'<']) }
  it { should parse(">").as([:align=>'>']) }
  it { should parse("=").as([:align=>'=']) }
  it { should parse("<>").as([{:align=>'<'}, {:align=>'>'}]) }

  it { should parse("-").as([:vertical_align=>'-']) }
  it { should parse("^").as([:vertical_align=>'^']) }
  it { should parse("~").as([:vertical_align=>'~']) }
  it { should parse("=~").as([{:align=>'='}, {:vertical_align=>'~'}]) }
  
  it { should parse("(").as([:padding=>'(']) }
  it { should parse(")").as([:padding=>')']) }
  it { should parse("()").as([{:padding=>'('}, {:padding=>')'}]) }
  it { should parse("(())").as([{:padding=>'('}, {:padding=>'('}, {:padding=>')'}, {:padding=>')'}]) }
  it { should parse("()(").as([{:padding=>'('}, {:padding=>')'}, {:padding=>'('}]) }
  
  it { should parse("<(").as([{:align=>"<"}, {:padding=>'('}]) }
  it { should parse("(<").as([{:padding=>'('}, {:align=>"<"}]) }
  it { should parse("(<)").as([{:padding=>'('}, {:align=>"<"}, {:padding=>')'}]) }
  it { should parse(")=(").as([{:padding=>')'}, {:align=>"="}, {:padding=>'('}]) }
  
  
end