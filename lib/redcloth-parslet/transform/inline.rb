class RedClothParslet::Transform::Inline < Parslet::Transform
  
  rule(:s => simple(:s)) do 
    Nokogiri::XML::Text.new(s, doc)
  end
  
  rule(:inline => simple(:i), :content => sequence(:c), :attributes => subtree(:a)) do
    name = {'*'=>'strong', '_'=>'em'}[i]
    Nokogiri::XML::Element.new(name, doc) do |n|
      a.each do |attrs|
        attrs.each do |k,v|
          n[k.to_s] = ((n[k.to_s] || '').split(/\s/) + [v]).join(' ')
        end
      end
      n.add_child(Nokogiri::XML::NodeSet.new(doc, c))
    end
  end

  def initialize(doc)
    @doc = doc
    super()
  end
  # Overrides Parslet::Transform#transform_elt to inject doc 
  # into bindings. Wouldn't have to do this if #call_on_match 
  # were evaluated in the context of the transform instance.
  def transform_elt(elt) # :nodoc: 
    rules.each do |pattern, block|
      if bindings=pattern.match(elt)
        bindings[:doc] = @doc
        # Produces transformed value
        return pattern.call_on_match(bindings, block)
      end
    end
    
    # No rule matched - element is not transformed
    return elt
  end
end
