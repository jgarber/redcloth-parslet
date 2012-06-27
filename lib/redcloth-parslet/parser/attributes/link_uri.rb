class RedClothParslet::Parser::Attributes::LinkUri < RedClothParslet::Parser::Attributes::ImageUri
  
  rule(:segment) { (safe_pchar | parenthesized_pchars).repeat >> (unsafe.absent? >> str(';') >> param).repeat }
  rule(:safe_pchar) { unsafe.absent? >> pchar }
  rule(:parenthesized_pchars) { str("(") >> safe_pchar.repeat >> str(")") }
  
  rule(:rel_segment) { (safe_rel_segment_chars | parenthesized_rel_segment_chars).repeat(1) }
  rule(:safe_rel_segment_chars) { unsafe.absent? >> (unreserved | escaped | match('[;@&=+$,]')) }
  rule(:parenthesized_rel_segment_chars) { str("(") >> safe_rel_segment_chars.repeat >> str(")") }
  
  rule(:fragment) { (safe_uric | parenthesized__uric).repeat }
  
  rule(:query) { (safe_uric | parenthesized__uric).repeat }
  
  rule(:safe_uric) { (unsafe.absent? >> uric) }
  rule(:parenthesized__uric) { str("(") >> safe_uric.repeat >> str(")") }
  
end
