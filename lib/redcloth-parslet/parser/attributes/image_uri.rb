class RedClothParslet::Parser::Attributes::ImageUri < RedClothParslet::Parser::Attributes::Uri
  
  rule(:segment) { (unsafe.absent? >> pchar).repeat >> (str(';') >> param).repeat }
  
  rule(:rel_segment) { (unsafe.absent? >> (unreserved | escaped | match('[;@&=+$,]'))).repeat(1) }
  
  rule(:reg_name) { (unsafe.absent? >> (unreserved | escaped | match('[$,;:@&=+]'))).repeat(1) }
  
  rule(:fragment) { (unsafe.absent? >> uric).repeat }
  
  rule(:query) { (unsafe.absent? >> uric).repeat }
  
  # Don't allow these in a URI
  rule(:unsafe) { match('[()]') | terminal_punctuation }
  
  # Greedy punctuation is okay inside a URI, but not at the e
  rule(:terminal_punctuation) { greedy_punctuation >> (str(':') | (pchar | match['#/;']).absent?) }
  
  # In the context of inline Textile, these may not terminate a URI
  rule(:greedy_punctuation) { match('[;!.",]').repeat }
  
end
