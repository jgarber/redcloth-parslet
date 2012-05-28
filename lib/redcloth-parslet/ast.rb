module RedClothParslet
  # Classes in this module represent the Abstract Syntax Tree (AST)
  # that gets built when a Textile document is parsed.
  #
  # The AST can be traversed with a visitor. See RedClothParslet::Format::HTML
  # for an example.
  module Ast
    # Allow AST classes to be instantiated with a method call
    # Example: #p is the same as RedClothParslet::Ast::P.new
    def method_missing(m, *args)
      constant = RedClothParslet::Ast
      klass = m.to_s.gsub(/(?:_)?([a-z\d]*)/i) { $1.capitalize }
      if constant.const_defined?(klass)
        constant.const_get(klass).new(*args)
      else
        super
      end
    end
  end
end

require 'redcloth-parslet/ast/attributes'
require 'redcloth-parslet/ast/base'
require 'redcloth-parslet/ast/entity'
require 'redcloth-parslet/ast/dimension'
require 'redcloth-parslet/ast/element'
require 'redcloth-parslet/ast/inline'
require 'redcloth-parslet/ast/block'
