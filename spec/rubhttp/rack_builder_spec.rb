# frozen_string_literal: true

RSpec.describe Rubhttp::RackBuilder do
  subject(:builder) { described_class.new }

  before do
    stub_const('AlphaMiddleware', Class.new(Rubhttp::Middleware))
    stub_const('BetaMiddleware', Class.new(Rubhttp::Middleware))
    stub_const('GammaMiddleware', Class.new(Rubhttp::Middleware))
  end

  describe '.app' do
    it 'returns a default rubhttp middleware' do
      expect(described_class.app).to be_a Rubhttp::Adapters::HTTP
    end

    it 'yields the rack builder to a block' do
      rack_builder = nil
      described_class.app { |b| rack_builder = b }
      expect(rack_builder).to be_a described_class
    end
  end

  describe '#app' do
    before do
      builder.use AlphaMiddleware
      builder.use BetaMiddleware
    end

    it 'returns a stacked app' do
      app = builder.app
      expect(app).to be_a AlphaMiddleware
      expect(app.app).to be_a BetaMiddleware
      expect(app.app.app).to be_a Rubhttp::Adapters::HTTP
    end

    it 'frozen all middlewares after app created' do
      app = builder.app
      expect(app).to be_frozen
      expect(app.app).to be_frozen
      expect(app.app.app).to be_frozen
    end

    it 'locks the middleware stack after app created' do
      _app = builder.app
      expect { builder.use GammaMiddleware }.to raise_error Rubhttp::RackBuilder::LockedError
    end
  end
end
