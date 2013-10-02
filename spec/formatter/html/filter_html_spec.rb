describe RedClothParslet::Formatter::HTML do
  describe 'filtered_html' do
    subject { described_class.new(:sort_attributes => true).convert(doc) }
    let(:doc) { RedClothParslet::TextileDoc.new('<div>', [:filter_html])}
    it "should encode all HTML tags" do
      subject.should == "&lt;div&gt;"
    end
  end
end
