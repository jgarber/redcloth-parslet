module RedClothParslet
  
  # A convenience method for creating a new TextileDoc. See
  # RedClothParslet::TextileDoc.
  def self.new( *args, &block )
    RedClothParslet::TextileDoc.new( *args, &block )
  end
  
end

require "parslet"
require "redcloth-parslet/parser"
require 'redcloth-parslet/transform'
require 'redcloth-parslet/ast'
require 'redcloth-parslet/formatter'
require 'redcloth-parslet/textile_doc'