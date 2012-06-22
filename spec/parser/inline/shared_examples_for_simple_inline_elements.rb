shared_examples 'a simple inline element' do |rule_name, mark, ast_class|
  # These were conceived as examples for strong (*) but apply to all simple inlines
  describe "specific parser rule" do
    it "should consume a #{rule_name} word" do
      parser.send(rule_name).should parse("#{mark}hey#{mark}")
    end

    it "should consume a #{rule_name} phrase" do
      parser.send(rule_name).should parse("#{mark}hey now!#{mark}")
    end

    it "should allow standalone #{mark}" do
      parser.send(rule_name).should parse("#{mark}Five #{mark} five is twenty-five#{mark}").with(transform).
        as(ast_class.new(["Five #{mark} five is twenty-five"]))
    end

    it "should pass internal #{rule_name}_start as plain text" do
      parser.send(rule_name).should parse("#{mark}A little #{mark}pearl here.#{mark}").with(transform).
      as(ast_class.new(["A little #{mark}pearl here."]))
    end

    it "should not parse #{rule_name} phrase containing #{rule_name}_end" do
      parser.send(rule_name).should_not parse("#{mark}Another pearl#{mark} there.#{mark}")
    end

    unless rule_name == "code"
      it "should not parse #{rule_name} phrase containing a newline" do
        parser.send(rule_name).should_not parse("#{mark}Line\nbreak.#{mark}")
      end
    end

    context "with attributes" do
      it { should parse("#{mark}(widget)This is something!#{mark}").with(transform).
           as(ast_class.new("This is something!", {:class=>"widget"}))
      }
    end

    context "enclosed in square brackets" do
      it { should parse("[#{mark}st#{mark}]").with(transform).
           as(ast_class.new("st")) }
    end
  end

  context "phrase" do
    it { should parse("#{mark}#{rule_name} phrase#{mark}").with(transform).
         as(ast_class.new("#{rule_name} phrase")) }

    it "should parse a #{rule_name} word surrounded by plain text" do
      subject.should parse("plain #{mark}#{rule_name}#{mark} plain").with(transform).
        as(["plain ", 
            ast_class.new("#{rule_name}"), 
            " plain"])
    end

    it "should parse a #{rule_name} phrase surrounded by plain text" do
      subject.should parse("plain #{mark}#{rule_name} phrase#{mark} plain").with(transform).
        as(["plain ", 
            ast_class.new("#{rule_name} phrase"), 
            " plain"])
    end

    it "should allow a #{rule_name} phrase at the end of a sentence before punctuation" do
      subject.should parse("Are you #{mark}veg#{mark}an#{mark}?").with(transform).
        as(["Are you ", ast_class.new("veg#{mark}an"),  "?"])
    end

    it "should parse a phrase with standalone #{mark}s that is not a #{rule_name} phrase" do
      subject.should parse("yes #{mark} we #{mark} can").with(transform).
        as("yes #{mark} we #{mark} can")
    end

    it "should parse a phrase with words containing #{mark} that is not a #{rule_name} phrase" do
      subject.should parse("The veg#{mark}an options are for veg#{mark}ans only.").with(transform).
        as("The veg#{mark}an options are for veg#{mark}ans only.")
    end

    it "should parse a phrase that is not a #{rule_name} because it has space at the end" do
      subject.should parse("yeah #{mark}that's #{mark} it!").with(transform).
        as("yeah #{mark}that's #{mark} it!")
    end

    it "should parse a phrase that is not a #{rule_name} because it has space at the beginning" do
      subject.should parse("oh, #{mark} here#{mark} it is!").with(transform).
      as("oh, #{mark} here#{mark} it is!")
    end

    it "should parse a #{rule_name} enclosed in square brackets that is part of a word" do
      subject.should parse("1[#{mark}st#{mark}]").with(transform).
        as(["1", ast_class.new("st")])
    end

    it "should parse a #{rule_name} enclosed in square brackets that contains spaces" do
      subject.should parse("[#{mark}p. #{mark}]").with(transform).
      as(ast_class.new("p. "))
    end
  end
end
