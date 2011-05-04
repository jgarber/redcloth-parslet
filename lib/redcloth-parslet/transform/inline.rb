class RedClothParslet::Transform::Inline < Parslet::Transform
  attr_accessor :doc

  def initialize(doc)
    @doc = doc
    super()
  end

  rule(:s => simple(:s)) do |match|
    Nokogiri::XML::Text.new(match[:s], doc)
  end
  
  rule(:inline => simple(:i), :content => sequence(:c), :attributes => subtree(:a)) do |match|
    name = {'*'=>'strong', '_'=>'em'}[match[:i]]
    Nokogiri::XML::Element.new(name, doc) do |n|
      match[:a].each do |attrs|
        attrs.each do |k,v|
          n[k.to_s] = ((n[k.to_s] || '').split(/\s/) + [v]).join(' ')
        end
      end
      n.add_child(Nokogiri::XML::NodeSet.new(doc, match[:c]))
    end
  end

end
