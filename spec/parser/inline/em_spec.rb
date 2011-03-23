describe RedClothParslet::Parser::Inline do
  let(:parser) { described_class.new }
  
  describe "#em" do
    it "should consume an emphasized word" do
      parser.em.should parse('_wow_')
    end

    it "should consume an emphasized phrase" do
      parser.em.should parse('_gee whiz!_')
    end
    
    it "should pass internal em_start as plain text" do
      parser.em.should parse('_Written by _why the lucky stiff_').
        as({:inline=>"_", :content=>[{:s=>"Written"}, {:s=>" "}, {:s=>"by"}, {:s=>" "}, {:s=>"_why"}, {:s=>" "}, {:s=>"the"}, {:s=>" "}, {:s=>"lucky"}, {:s=>" "}, {:s=>"stiff"}]})
    end
    
    it "should not parse an emphasized phrase containing em_end" do
      parser.em.should_not parse('_the mouse_ has a tail_')
    end
    
  end
  
  context "em phrase" do
    it { should parse("_em phrase_").
      as([{:inline=>"_", :content=>[{:s=>"em"}, {:s=>" "}, {:s=>"phrase"}]}]) }
    
    it "should parse an emphasized word surrounded by plain text" do
      subject.should parse("plain _em_ plain").
      as([{:s=>"plain"}, {:s=>" "}, 
          {:inline=>"_", :content=>[{:s=>"em"}]}, 
          {:s=>" "}, {:s=>"plain"}])
    end
    
    it "should parse an emphasized phrase surrounded by plain text" do
      subject.should parse("plain _em phrase_ plain").
      as([{:s=>"plain"}, {:s=>" "}, 
          {:inline=>"_", :content=>[{:s=>"em"}, {:s=>" "}, {:s=>"phrase"}]}, 
          {:s=>" "}, {:s=>"plain"}])
    end
    
    it "should allow an emphasized phrase at the end of a sentence before punctuation" do
      subject.should parse("Are you _fo' realz_?").
        as([{:s=>"Are"}, {:s=>" "}, {:s=>"you"}, {:s=>" "}, {:inline=>"_", :content=>[{:s=>"fo'"}, {:s=>" "}, {:s=>"realz"}]}, {:s=>"?"}])
    end

    it "should parse a phrase with underscored words that is not an emphasized phrase" do
      subject.should parse("The form_test_helper plugin was my first.").
        as([{:s=>"The"}, {:s=>" "}, {:s=>"form_test_helper"}, {:s=>" "}, {:s=>"plugin"}, {:s=>" "}, {:s=>"was"}, {:s=>" "}, {:s=>"my"}, {:s=>" "}, {:s=>"first."}])
    end

    it "should parse a phrase that is not emphasized because it has space at the end" do
      subject.should parse("no _em _ here!").
        as([{:s=>"no"}, {:s=>" "}, {:s=>"_em"}, {:s=>" "}, {:s=>"_"}, {:s=>" "}, {:s=>"here!"}])
    end
    
    it "should parse a phrase that is not emphasized because it has space at the beginning" do
      subject.should parse("surely you _ can't_ be serious").
        as([{:s=>"surely"}, {:s=>" "}, {:s=>"you"}, {:s=>" "}, {:s=>"_"}, {:s=>" "}, {:s=>"can't_"}, {:s=>" "}, {:s=>"be"}, {:s=>" "}, {:s=>"serious"}])
    end
  end
  
end