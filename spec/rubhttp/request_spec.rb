# frozen_string_literal: true

RSpec.describe Rubhttp::Request do
  describe 'getters' do
    subject(:request) { described_class.new(verb: verb, uri: uri, headers: headers, body: body) }

    let(:verb) { :get }
    let(:uri) { 'http://www.example.com' }
    let(:headers) { { accept: 'application/json' } }
    let(:body) { '{"msg":"ok"}' }

    it 'provides a #verb accessor' do
      expect(request.verb).to eq(:get)
    end

    it 'provides a #uri accessor' do
      expect(request.uri).to be_a Rubhttp::Uri
      expect(request.uri.to_s).to eq('http://www.example.com/')
    end

    it 'provides a #headers accessor' do
      expect(request.headers).to be_a Rubhttp::Headers
      expect(request.headers.to_h).to eq('Accept' => 'application/json')
    end

    it 'provides a #body accessor' do
      expect(request.body).to be_a Rubhttp::Request::Body
      expect(request.body.contents).to eq(body: '{"msg":"ok"}')
    end

    context 'when pass :params option' do
      subject(:request) { described_class.new(verb: verb, uri: uri, params: { foo: 'bar' }) }

      it 'adds query string parameters to uri' do
        expect(request.uri.to_s).to eq('http://www.example.com/?foo=bar')
      end
    end
  end
end
