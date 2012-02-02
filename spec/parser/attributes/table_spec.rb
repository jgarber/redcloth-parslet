describe RedClothParslet::Parser::Attributes do
  subject { described_class.new.table_attributes }
  
  it { should parse("\\2").as([:colspan=>'2']) }
  it { should parse("\\7").as([:colspan=>'7']) }
  it { should parse("/3").as([:rowspan=>'3']) }
  it { should parse("/5").as([:rowspan=>'5']) }
  
  it { should parse("-").as([:vertical_align=>'-']) }
  it { should parse("^").as([:vertical_align=>'^']) }
  it { should parse("~").as([:vertical_align=>'~']) }
  it { should parse("=~").as([{:align=>'='}, {:vertical_align=>'~'}]) }
end
