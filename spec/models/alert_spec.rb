require 'rails_helper'

RSpec.describe Alert, type: :model do
  describe '#normalize_symbol' do
    it 'uppercases and appends USDT when missing' do
      alert = described_class.new(symbol: 'btc', threshold: 10000, direction: :up)
      alert.validate
      expect(alert.symbol).to eq('BTCUSDT')
    end

    it 'keeps existing USDT suffix' do
      alert = described_class.new(symbol: 'ethusdt', threshold: 1000, direction: :down)
      alert.validate
      expect(alert.symbol).to eq('ETHUSDT')
    end
  end

  describe '#crossed?' do
    let(:alert_up) { described_class.new(symbol: 'BTCUSDT', threshold: 30000, direction: :up, last_price: 29999) }
    let(:alert_down) { described_class.new(symbol: 'BTCUSDT', threshold: 30000, direction: :down, last_price: 30001) }

    it 'detects upward cross' do
      expect(alert_up.crossed?(30000)).to be true
      expect(alert_up.crossed?(29950)).to be false
    end

    it 'detects downward cross' do
      expect(alert_down.crossed?(30000)).to be true
      expect(alert_down.crossed?(30050)).to be false
    end

    it 'does not trigger when last_price is nil' do
      alert = described_class.new(symbol: 'BTCUSDT', threshold: 30000, direction: :up)
      expect(alert.crossed?(30010)).to be false
    end
  end
end
