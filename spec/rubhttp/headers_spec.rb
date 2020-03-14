# frozen_string_literal: true

RSpec.describe Rubhttp::Headers do
  subject(:headers) { described_class.new }

  describe '#set' do
    it 'sets header value' do
      headers.set 'Accept', 'application/json'
      expect(headers['Accept']).to eq 'application/json'
    end

    it 'allows retrieval via normalized header name' do
      headers.set :content_type, 'application/json'
      expect(headers['Content-Type']).to eq 'application/json'
    end

    it 'overwrites previous value' do
      headers.set :set_cookie, 'hoo=ray'
      headers.set :set_cookie, 'woo=hoo'
      expect(headers['Set-Cookie']).to eq 'woo=hoo'
    end

    it 'allows set multiple values' do
      headers.set :set_cookie, 'hoo=ray'
      headers.set :set_cookie, %w[hoo=ray woo=hoo]
      expect(headers['Set-Cookie']).to eq %w[hoo=ray woo=hoo]
    end

    it 'fails with empty header name' do
      expect do
        headers.set '', 'foo bar'
      end.to raise_error Rubhttp::HeaderError
    end

    ['foo bar', "foo bar: ok\nfoo", "evil-header: evil-value\nfoo"].each do |name|
      it "fails with invalid header name (#{name.inspect})" do
        expect do
          headers.set name, 'baz'
        end.to raise_error Rubhttp::HeaderError
      end
    end
  end

  describe '#get' do
    before { headers.set('Content-Type', 'application/json') }

    it 'returns array of associated values' do
      expect(headers.get('Content-Type')).to eq %w[application/json]
    end

    it 'normalizes header name' do
      expect(headers.get(:content_type)).to eq %w[application/json]
    end

    context 'when header does not exists' do
      it 'returns empty array' do
        expect(headers.get(:accept)).to eq []
      end
    end
  end

  describe '#[]' do
    context 'when header does not exists' do
      it 'returns nil' do
        expect(headers[:accept]).to be_nil
      end
    end

    context 'when header has a single value' do
      before { headers.set 'Content-Type', 'application/json' }

      it 'normalizes header name' do
        expect(headers[:content_type]).not_to be_nil
      end

      it 'returns it returns a single value' do
        expect(headers[:content_type]).to eq 'application/json'
      end
    end

    context 'when header has a multiple values' do
      before do
        headers.add :set_cookie, 'hoo=ray'
        headers.add :set_cookie, 'woo=hoo'
      end

      it 'normalizes header name' do
        expect(headers[:set_cookie]).not_to be_nil
      end

      it 'returns array of associated values' do
        expect(headers[:set_cookie]).to eq %w[hoo=ray woo=hoo]
      end
    end
  end

  describe '#add' do
    it 'sets header value' do
      headers.add 'Accept', 'application/json'
      expect(headers['Accept']).to eq 'application/json'
    end

    it 'allows retrieval via normalized header name' do
      headers.add :content_type, 'application/json'
      expect(headers['Content-Type']).to eq 'application/json'
    end

    it 'appends new value if header exists' do
      headers.add 'Set-Cookie', 'hoo=ray'
      headers.add :set_cookie, 'woo=hoo'
      expect(headers['Set-Cookie']).to eq %w[hoo=ray woo=hoo]
    end

    it 'allows append multiple values' do
      headers.add :set_cookie, 'hoo=ray'
      headers.add :set_cookie, %w[woo=hoo yup=pie]
      expect(headers['Set-Cookie']).to eq %w[hoo=ray woo=hoo yup=pie]
    end

    it 'fails with empty header name' do
      expect do
        headers.add('', 'foobar')
      end.to raise_error Rubhttp::HeaderError
    end

    ['foo bar', "foo bar: ok\nfoo"].each do |name|
      it "fails with invalid header name (#{name.inspect})" do
        expect do
          headers.add name, 'baz'
        end.to raise_error Rubhttp::HeaderError
      end
    end

    it 'fails when header name is not a String or Symbol' do
      expect do
        headers.add 2, 'foo'
      end.to raise_error Rubhttp::HeaderError
    end
  end

  describe '#delete' do
    before { headers.set 'Content-Type', 'application/json' }

    it 'removes given header' do
      headers.delete 'Content-Type'
      expect(headers['Content-Type']).to be_nil
    end

    it 'removes header that matches normalized version of specified name' do
      headers.delete :content_type
      expect(headers['Content-Type']).to be_nil
    end
  end

  describe '#to_h' do
    before do
      headers.add :content_type, 'application/json'
      headers.add :set_cookie,   'hoo=ray'
      headers.add :set_cookie,   'woo=hoo'
    end

    it 'returns a Hash' do
      expect(headers.to_h).to be_a Hash
    end

    it 'returns Hash with normalized keys' do
      expect(headers.to_h.keys).to match_array %w[Content-Type Set-Cookie]
    end

    context 'when a header with single value' do
      it 'provides a value as is' do
        expect(headers.to_h['Content-Type']).to eq 'application/json'
      end
    end

    context 'when a header with multiple values' do
      it 'provides an array of values' do
        expect(headers.to_h['Set-Cookie']).to eq %w[hoo=ray woo=hoo]
      end
    end
  end

  describe '#to_a' do
    before do
      headers.add :content_type, 'application/json'
      headers.add :set_cookie,   'hoo=ray'
      headers.add :set_cookie,   'woo=hoo'
    end

    it 'returns an Array' do
      expect(headers.to_a).to be_a Array
    end

    it 'returns Array of key/value pairs with normalized keys' do
      expect(headers.to_a).to eq [
        %w[Content-Type application/json],
        %w[Set-Cookie hoo=ray],
        %w[Set-Cookie woo=hoo]
      ]
    end
  end
end
