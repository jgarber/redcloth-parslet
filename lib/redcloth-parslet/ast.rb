module RedClothParslet
  # Classes in this module represent the Abstract Syntax Tree (AST)
  # that gets built when a Textile document is parsed.
  #
  # The AST can be traversed with a visitor. See RedClothParslet::Format::HTML
  # for an example.
  module Ast
    
  end
end

require 'redcloth-parslet/ast/attributes'
require 'redcloth-parslet/ast/element'
require 'redcloth-parslet/ast/inline'
require 'redcloth-parslet/ast/block'
