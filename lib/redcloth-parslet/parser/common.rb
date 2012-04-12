module RedClothParslet::Parser::Common
  include Parslet

  def stri(str)
    key_chars = str.split(//)
    key_chars.
      collect! { |char| match["#{char.upcase}#{char.downcase}"] }.
      reduce(:>>)
  end

  rule(:digits) { match('[0-9]').repeat(1) }
end
