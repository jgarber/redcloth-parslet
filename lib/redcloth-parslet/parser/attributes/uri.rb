class RedClothParslet::Parser::Attributes::Uri < Parslet::Parser

  rule(:uri) { absolute_uri | absolute_path | relative_path }
  root(:uri)

  #
  # Character Classes
  #
  rule(:digit) { match('[0-9]') }
  rule(:xdigit) { digit | match('[a-fA-F]') }
  rule(:upper) { match('[A-Z]') }
  rule(:lower) { match('[a-z]') }
  rule(:alpha) { upper | lower }
  rule(:cntrl) { match('[\x00-\x1f]') }
  
  rule(:sp) { str(' ') }
  
  rule(:ctl) { cntrl | str("\x7f") }
  rule(:safe) { str('$') | str('-') | str('_') | str('.') }
  rule(:extra) {
    str('!') | str('*') | str("'") | str('(') | str(')') | str(',')
  }
  rule(:reserved) {
    str(';') | str('/') | str('?') | str(':') | str('@')
    str('&') | str('=') | str('+')
  }
  rule(:sorta_safe) { str('"') | str('<') | str('>') }
  rule(:unsafe) { ctl | sp | str('#') | str('%') | sorta_safe }
  rule(:national) {
    (alpha | digit | reserved | extra | safe | unsafe).absnt? >> any
  }
  
  rule(:unreserved) { alpha | digit | safe | extra | national }
  rule(:escape) { str("%").maybe >> xdigit >> xdigit }
  rule(:uchar) { unreserved | escape | sorta_safe }
  rule(:pchar) {
    uchar | str(':') | str('@') | str('&') | str('=') | str('+')
  }
  
  #
  # URI Elements
  #
  rule(:scheme) {
    (alpha | digit | str('+') | str('-') | str('.')).repeat
  }
  
  rule(:absolute_uri) { scheme >> str(':') >> (uchar | reserved).repeat }
  
  rule(:path) { pchar.repeat(1) >> (str('/') >> pchar.repeat).repeat }
  rule(:query_string) { (uchar | reserved).repeat }
  rule(:param) { (pchar | str('/')).repeat }
  rule(:params) { param >> (str(';') >> param).repeat }
  rule(:frag) { (uchar | reserved).repeat }
  
  rule(:relative_path) {
    path.maybe.as(:path) >>
    (str(';') >> params.as(:params)).maybe >>
    (str('?') >> query_string.as(:query)).maybe >>
    (str('#') >> frag.as(:fragment)).maybe
  }
  rule(:absolute_path) { str('/').repeat(1) >> relative_path }
end
