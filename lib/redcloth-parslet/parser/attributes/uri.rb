class RedClothParslet::Parser::Attributes::Uri < Parslet::Parser
  
  # Ported from URI in Ruby 1.9.2
  # References:
  #   RFC 2396 (URI Generic Syntax)
  #   RFC 2732 (IPv6 Literal Addresses in URL's)
  #   RFC 2373 (IPv6 Addressing Architecture)
  
  # URI-reference = [ absoluteURI | relativeURI ] [ "#" fragment ]
  rule(:uri) {
    (abs_uri | rel_uri) >> (str('#') >> fragment).maybe |
    str('#') >> fragment
  }
  root(:uri)
  
  # absoluteURI   = scheme ":" ( hier_part | opaque_part )
  rule(:abs_uri) { scheme >> str(':') >> (hier_part | opaque_part) }
  
  # relativeURI   = ( net_path | abs_path | rel_path ) [ "?" query ]
  rule(:rel_uri) { (net_path | abs_path | rel_path) >> (str('?') >> query).maybe }
  
  # pchar         = unreserved | escaped |
  #                 ":" | "@" | "&" | "=" | "+" | "$" | ","
  rule(:pchar) { unreserved | escaped | match('[:@&=+$,]') }
  
  # param         = *pchar
  rule(:param) { pchar.repeat }
  
  # segment       = *pchar *( ";" param )
  rule(:segment) { pchar.repeat >> (str(';') >> param).repeat }
  
  # path_segments = segment *( "/" segment )
  rule(:path_segments) { segment >> (str('/') >> segment).repeat }
  
  # server        = [ [ userinfo "@" ] hostport ]
  rule(:server) { (userinfo >> str('@')).maybe >> hostport }
  
  # reg_name      = 1*( unreserved | escaped | "$" | "," |
  #                     ";" | ":" | "@" | "&" | "=" | "+" )
  rule(:reg_name) { (unreserved | escaped | match('[$,;:@&=+]')).repeat(1) }
  
  # authority     = server | reg_name
  rule(:authority) { server | reg_name }
  
  # rel_segment   = 1*( unreserved | escaped |
  #                     ";" | "@" | "&" | "=" | "+" | "$" | "," )
  rule(:rel_segment) { (unreserved | escaped | match('[;@&=+$,]')).repeat(1) }
  
  # scheme        = alpha *( alpha | digit | "+" | "-" | "." )
  rule(:scheme) { alpha >> (match('[-+.a-zA-Z\d]')).repeat }
  
  # abs_path      = "/"  path_segments
  rule(:abs_path) { str('/') >> path_segments }
  
  # rel_path      = rel_segment [ abs_path ]
  rule(:rel_path) { rel_segment >> abs_path.maybe }
  
  # net_path      = "//" authority [ abs_path ]
  rule(:net_path) { str('//') >> authority >> abs_path.maybe }
  
  # hier_part     = ( net_path | abs_path ) [ "?" query ]
  rule(:hier_part) { (net_path | abs_path) >> (str('?') >> query).maybe }
  
  # opaque_part   = uric_no_slash *uric
  rule(:opaque_part) { uric_no_slash >> uric.repeat }
  
  
  # RFC 2373, APPENDIX B:
  # IPv6address = hexpart [ ":" IPv4address ]
  # IPv4address   = 1*3DIGIT "." 1*3DIGIT "." 1*3DIGIT "." 1*3DIGIT
  # hexpart = hexseq | hexseq "::" [ hexseq ] | "::" [ hexseq ]
  # hexseq  = hex4 *( ":" hex4)
  # hex4    = 1*4HEXDIG
  #
  # XXX: This definition has a flaw. "::" + IPv4address must be
  # allowed too.  Here is a replacement.
  #
  # IPv4address = 1*3DIGIT "." 1*3DIGIT "." 1*3DIGIT "." 1*3DIGIT
  rule(:ipv4addr) do
    match('\d').repeat(1,3) >> str('.') >>
    match('\d').repeat(1,3) >> str('.') >>
    match('\d').repeat(1,3) >> str('.') >>
    match('\d').repeat(1,3)
  end
  
  # hex4     = 1*4HEXDIG
  rule(:hex4) { hex.repeat(1,4) }
  
  # lastpart = hex4 | IPv4address
  rule(:lastpart) { ipv4addr | hex4 }
  
  # hexseq1  = *( hex4 ":" ) hex4
  rule(:hexseq1) { (hex4 >> str(':') >> hex4.present?).repeat >> hex4 }
  
  # hexseq2  = *( hex4 ":" ) lastpart
  rule(:hexseq2) { (hex4 >> str(':') >> lastpart.present?).repeat >> lastpart }
  
  # IPv6address = hexseq2 | [ hexseq1 ] "::" [ hexseq2 ]
  rule(:ipv6addr) do
    hexseq1.maybe >> str('::') >> hexseq2.maybe |
    hexseq2
  end
  
  # IPv6prefix  = ( hexseq1 | [ hexseq1 ] "::" [ hexseq1 ] ) "/" 1*2DIGIT
  # unused
  
  # ipv6reference = "[" IPv6address "]" (RFC 2732)
  rule(:ipv6ref) { str('[') >> ipv6addr >> str(']') }
  
  # domainlabel   = alphanum | alphanum *( alphanum | "-" ) alphanum
  rule(:domainlabel) { alphanum >> ((alphanum >> alphanum.present?).repeat >> alphanum).maybe }
  
  # toplabel      = alpha | alpha *( alphanum | "-" ) alphanum
  rule(:toplabel) { alpha >> ((alphanum >> alphanum.present?).repeat >> alphanum).maybe }
  
  # hostname      = *( domainlabel "." ) toplabel [ "." ]
  rule(:hostname) { (domainlabel >> str('.')).repeat >> toplabel >> str('.').maybe }
  
  # host          = hostname | IPv4address
  # host          = hostname | IPv4address | IPv6reference (RFC 2732)
  rule(:host) { hostname | ipv4addr | ipv6ref }
  
  # port          = *digit
  rule(:port) { match('\d').repeat }
  
  # hostport      = host [ ":" port ]
  rule(:hostport) { host >> (str(':') >> port).maybe }
  
  # userinfo      = *( unreserved | escaped |
  #                    ";" | ":" | "&" | "=" | "+" | "$" | "," )
  rule(:userinfo) { (unreserved | escaped | match('[;:&=+$,]')).repeat }
  
  # fragment      = *uric
  rule(:fragment) { uric.repeat }
  
  # query         = *uric
  rule(:query) { uric.repeat }
  
  # uric_no_slash = unreserved | escaped | ";" | "?" | ":" | "@" |
  #                 "&" | "=" | "+" | "$" | ","
  rule(:uric_no_slash) { unreserved | escaped | match('[;?:@&=+$,]') }
  
  # uric          = reserved | unreserved | escaped
  rule(:uric) { reserved | unreserved | escaped }
  
  # reserved      = ";" | "/" | "?" | ":" | "@" | "&" | "=" | "+" |
  #                 "$" | ","
  # reserved      = ";" | "/" | "?" | ":" | "@" | "&" | "=" | "+" | 
  #                 "$" | "," | "[" | "]" (RFC 2732)
  rule(:reserved) { match('[;/?:@&=+,\[\]]') }
  
  # mark          = "-" | "_" | "." | "!" | "~" | "*" | "'" |
  #                 "(" | ")"
  # unreserved    = alphanum | mark
  rule(:unreserved) { match('[-_.!~*''()a-zA-Z\d]') }
  
  # escaped       = "%" hex hex
  rule(:escaped) { str('%') >> hex >> hex }
  
  # hex           = digit | "A" | "B" | "C" | "D" | "E" | "F" |
  #                         "a" | "b" | "c" | "d" | "e" | "f"
  rule(:hex) { match('[a-fA-F\d]') }
  
  rule(:alpha) { match('[a-zA-Z]') }
  rule(:alphanum) { match('[a-zA-Z\d]') }
  
end
