describe RedClothParslet::Parser::Attributes::Uri do
  let(:parser) { described_class.new }

  it { should parse("http://google.com") }
  it { should parse("foo") }
  it { should parse("/bar") }

  %w(ftp http https gopher mailto news nntp telnet wais file prospero).each do |scheme|
    it { should parse("#{scheme}://redcloth.org/") }
  end
  it { should parse("mailto:xxx@xxx.xxx.xxx") }

  it { should parse("http://redcloth.org/foo/bar/baz") }
  it { should parse("http://redcloth.org/") }
  it { should parse("http://localhost") }
  it { should parse("http://localhost:3000") }
  it { should parse("http://localhost:1") }
  it { should parse("http://localhost:65536") }
  it { should parse("http://192.168.1.1") }
  it { should parse("http://localhost:3000/foo?bar=baz") }
  it { should parse("http://localhost:3000/foo?bar=baz&foo=bar") }
  it { should parse("http://localhost:3000/foo?bar=baz&foo=bar&one=two") }
  it { should parse("http://localhost:3000/foo?bar=1&foo=2") }
  it { should parse("/foo/bar.html") }
  it { should parse("#Examples_of_URI_references") }
  it { should parse("URI#Examples_of_URI_references") }
  it { should parse("#") }
  it { should parse("image.jpg") }
  it { should parse("http://example.com/r?url=http%3A%2F%2Fwww.redcloth.org") }
  it { should parse("../foo/./bar") }
  it { should parse("ftp://ftp.is.co.za/%2Frfc/rfc1808.txt") }
  it { should parse("gopher://spinaltap.micro.umn.edu/00/Weather/California/Los%20Angeles") }
  it { should parse("http://www.math.uio.no/faq/compression-faq/part1.html") }
  it { should parse("http://en.wikipedia.org/wiki/Textile_(markup_language)") }
  it { should parse("mailto:mduerst@ifi.unizh.ch") }
  it { should parse("news:comp.infosystems.www.servers.unix") }
  it { should parse("telnet://melvyl.ucop.edu/") }

  it { should parse("file:///foo/bar.txt") }
  it { should parse("file:/foo/bar.txt") }
  it { should parse("ftp://:pass@localhost/") }
  it { should parse("ftp://user@localhost/") }
  it { should parse("ftp://localhost/") }

  it { should parse("http://[FEDC:BA98:7654:3210:FEDC:BA98:7654:3210]:80/index.html") }
  it { should parse("http://[1080:0:0:0:8:800:200C:417A]/index.html") }
  it { should parse("http://[3ffe:2a00:100:7031::1]") }
  it { should parse("http://[1080::8:800:200C:417A]/foo") }
  it { should parse("http://[::192.9.5.5]/ipng") }
  it { should parse("http://[::FFFF:129.144.52.38]:80/index.html") }
  it { should parse("http://[2010:836B:4179::836B:4179]") }

  it { should_not parse("http://a_b:80/") }
  it { should_not parse("http://a_b/") }
end
