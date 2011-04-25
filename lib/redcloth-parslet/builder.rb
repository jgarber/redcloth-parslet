require 'parslet'
require 'nokogiri'

module RedClothParslet::Builder
  module Context
    
    def doc
      @bindings[:doc]
    end
    
  end
end

Parslet::Pattern::Context.send :include, RedClothParslet::Builder::Context
