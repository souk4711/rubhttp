# frozen_string_literal: true

RSpec.describe Rubhttp::Response::Status do
  describe '#code' do
    subject(:status) { described_class.new(200) }

    it { expect(status.code).to eq 200 }
    it { expect(status.code).to be_a Integer }
  end

  describe '#reason' do
    subject(:status) { described_class.new(code) }

    context 'with unknown code' do
      let(:code) { 1024 }

      it { expect(status.reason).to be_nil }
    end

    described_class::REASONS.each do |code, reason|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        context 'with well-known code: #{code}' do
          let(:code) { #{code} }

          it { expect(status.reason).to eq #{reason.inspect} }
          it { expect(status.reason).to be_frozen }
        end
      RUBY
    end
  end

  context 'with 1xx codes' do
    subject(:status) { (100...200).map { |code| described_class.new(code) } }

    it 'is #informational?' do
      expect(status).to all(satisfy(&:informational?))
    end

    it 'is not #success?' do
      expect(status).to all(satisfy { |status| !status.success? })
    end

    it 'is not #redirect?' do
      expect(status).to all(satisfy { |status| !status.redirect? })
    end

    it 'is not #client_error?' do
      expect(status).to all(satisfy { |status| !status.client_error? })
    end

    it 'is not #server_error?' do
      expect(status).to all(satisfy { |status| !status.server_error? })
    end
  end

  context 'with 2xx codes' do
    subject(:status) { (200...300).map { |code| described_class.new(code) } }

    it 'is not #informational?' do
      expect(status).to all(satisfy { |status| !status.informational? })
    end

    it 'is #success?' do
      expect(status).to all(satisfy(&:success?))
    end

    it 'is not #redirect?' do
      expect(status).to all(satisfy { |status| !status.redirect? })
    end

    it 'is not #client_error?' do
      expect(status).to all(satisfy { |status| !status.client_error? })
    end

    it 'is not #server_error?' do
      expect(status).to all(satisfy { |status| !status.server_error? })
    end
  end

  context 'with 3xx codes' do
    subject(:status) { (300...400).map { |code| described_class.new(code) } }

    it 'is not #informational?' do
      expect(status).to all(satisfy { |status| !status.informational? })
    end

    it 'is not #success?' do
      expect(status).to all(satisfy { |status| !status.success? })
    end

    it 'is #redirect?' do
      expect(status).to all(satisfy(&:redirect?))
    end

    it 'is not #client_error?' do
      expect(status).to all(satisfy { |status| !status.client_error? })
    end

    it 'is not #server_error?' do
      expect(status).to all(satisfy { |status| !status.server_error? })
    end
  end

  context 'with 4xx codes' do
    subject(:status) { (400...500).map { |code| described_class.new(code) } }

    it 'is not #informational?' do
      expect(status).to all(satisfy { |status| !status.informational? })
    end

    it 'is not #success?' do
      expect(status).to all(satisfy { |status| !status.success? })
    end

    it 'is not #redirect?' do
      expect(status).to all(satisfy { |status| !status.redirect? })
    end

    it 'is #client_error?' do
      expect(status).to all(satisfy(&:client_error?))
    end

    it 'is not #server_error?' do
      expect(status).to all(satisfy { |status| !status.server_error? })
    end
  end

  context 'with 5xx codes' do
    subject(:status) { (500...600).map { |code| described_class.new(code) } }

    it 'is not #informational?' do
      expect(status).to all(satisfy { |status| !status.informational? })
    end

    it 'is not #success?' do
      expect(status).to all(satisfy { |status| !status.success? })
    end

    it 'is not #redirect?' do
      expect(status).to all(satisfy { |status| !status.redirect? })
    end

    it 'is not #client_error?' do
      expect(status).to all(satisfy { |status| !status.client_error? })
    end

    it 'is #server_error?' do
      expect(status).to all(satisfy(&:server_error?))
    end
  end
end
