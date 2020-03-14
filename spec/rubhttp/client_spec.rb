# frozen_string_literal: true

RSpec.describe Rubhttp::Client do
  subject(:client) { described_class.new }

  let(:uri) { "http://127.0.0.1:#{dummy_server_port}" }

  before(:all) { dummy_server_start! } # rubocop:disable RSpec/BeforeAfterAll

  after(:all) { dummy_server_stop! } # rubocop:disable RSpec/BeforeAfterAll

  describe '#head' do
    it 'returns no content with 204' do
      r = client.head(uri + '/book')
      expect(r.code).to eq(204)
      expect(r.body.to_s).to eq('')
    end
  end

  describe '#get' do
    it 'returns book info with 200' do
      r = client.get(uri + '/book')
      expect(r.code).to eq(200)
      expect(r.body.to_s).to eq('{"id":1,"name":"alpha"}')
    end

    context 'when GET /params' do
      it 'returns "foobar" when passing data use option :params' do
        r = client.get(uri + '/params', params: { foo: 'bar' })
        expect(r.body.to_s).to eq('params-foobar')
      end
    end
  end

  describe '#post' do
    it 'returns book info with 201' do
      r = client.post(uri + '/book')
      expect(r.code).to eq(201)
      expect(r.body.to_s).to eq('{"id":1,"name":"alpha"}')
    end

    context 'when POST /form' do
      it 'returns "foobar" when passing data use option :form' do
        r = client.post(uri + '/form', form: { foo: 'bar' })
        expect(r.body.to_s).to eq('form-foobar')
      end
    end

    context 'when POST /json' do
      it 'returns "foobar" when passing data use option :json' do
        r = client.post(uri + '/json', json: { foo: 'bar' })
        expect(r.body.to_s).to eq('json-foobar')
      end

      it 'returns "foobar" when passing data use option :body with raw string' do
        r = client.post(uri + '/json', body: '{"foo":"bar"}')
        expect(r.body.to_s).to eq('json-foobar')
      end

      it 'returns "foobar" when passing data use option :body with IO' do
        r = client.post(uri + '/json', body: StringIO.new('{"foo":"bar"}'))
        expect(r.body.to_s).to eq('json-foobar')
      end
    end
  end

  describe '#put' do
    it 'returns book info with 200' do
      r = client.put(uri + '/book')
      expect(r.code).to eq(200)
      expect(r.body.to_s).to eq('{"id":1,"name":"beta"}')
    end
  end

  describe '#delete' do
    it 'returns book info with 204' do
      r = client.delete(uri + '/book')
      expect(r.code).to eq(204)
      expect(r.body.to_s).to eq('')
    end
  end

  describe '#patch' do
    it 'returns book info with 200' do
      r = client.patch(uri + '/book')
      expect(r.code).to eq(200)
      expect(r.body.to_s).to eq('{"id":1,"name":"beta"}')
    end
  end
end
