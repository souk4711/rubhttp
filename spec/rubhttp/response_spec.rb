# frozen_string_literal: true

RSpec.describe Rubhttp::Response do
  describe 'getters' do
    subject(:response) { described_class.new(status: status, headers: headers, body: body) }

    let(:status) { 200 }
    let(:headers) { { accept: 'application/json' } }
    let(:body) { '{"msg":"ok"}' }

    it 'provides a #status accessor' do
      expect(response.status).to be_a Rubhttp::Response::Status
      expect(response.status.code).to eq(200)
    end

    it 'provides a #code accessor' do
      expect(response.code).to eq(200)
    end

    it 'provides a #reason accessor' do
      expect(response.reason).to eq('OK')
    end

    it 'provides a #headers accessor' do
      expect(response.headers).to be_a Rubhttp::Headers
      expect(response.headers.to_h).to eq('Accept' => 'application/json')
    end

    it 'provides a #body accessor' do
      expect(response.body).to be_a Rubhttp::Response::Body
      expect(response.body.to_s).to eq('{"msg":"ok"}')
    end
  end
end
