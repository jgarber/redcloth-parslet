class RedClothParslet::Parser::Attributes::NongreedyUri < RedClothParslet::Parser::Attributes::Uri
  
  rule(:segment) { (safe_pchar | parenthesized_pchars).repeat >> (str(';') >> param).repeat }
  rule(:safe_pchar) { unsafe.absent? >> pchar }
  rule(:parenthesized_pchars) { str("(") >> safe_pchar.repeat >> str(")") }
  
  rule(:rel_segment) { (safe_rel_segment_chars | parenthesized_rel_segment_chars).repeat(1) }
  rule(:safe_rel_segment_chars) { unsafe.absent? >> (unreserved | escaped | match('[;@&=+$,]')) }
  rule(:parenthesized_rel_segment_chars) { str("(") >> safe_rel_segment_chars.repeat >> str(")") }
  
  rule(:reg_name) { (unsafe.absent? >> (unreserved | escaped | match('[$,;:@&=+]'))).repeat(1) }
  
  rule(:fragment) { (safe_uric | parenthesized__uric).repeat }
  
  rule(:query) { (safe_uric | parenthesized__uric).repeat }
  
  rule(:safe_uric) { (unsafe.absent? >> uric) }
  rule(:parenthesized__uric) { str("(") >> safe_uric.repeat >> str(")") }
  
  # Don't allow these in a URI
  rule(:unsafe) { match('[()]') | terminal_punctuation }
  
  # Greedy punctuation is okay inside a URI, but not at the end
  rule(:terminal_punctuation) { greedy_punctuation >> (str(':') | (pchar | match('[#/;]')).absent?) }
  
  # In the context of inline Textile, these may not terminate a URI
  rule(:greedy_punctuation) { match('[!."]').repeat }
  
end
