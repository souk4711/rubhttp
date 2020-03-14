# frozen_string_literal: true

RSpec.describe Rubhttp::Uri do
  describe '.parse' do
    subject(:uri) { described_class.parse('http://www.example.com/abc?a=1&b=str#ref') }

    it 'gets its component parts' do
      expect(uri.scheme).to eq 'http'
      expect(uri.host).to eq 'www.example.com'
      expect(uri.path).to eq '/abc'
      expect(uri.query).to eq 'a=1&b=str'
      expect(uri.query_values).to eq('a' => '1', 'b' => 'str')
      expect(uri.fragment).to eq 'ref'
      expect(uri.to_s).to eq 'http://www.example.com/abc?a=1&b=str#ref'
    end
  end
end
