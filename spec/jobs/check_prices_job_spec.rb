require 'rails_helper'

RSpec.describe CheckPricesJob, type: :job do
  describe '#perform' do
    it 'updates last_price and notifies when crossed' do
      alert = Alert.create!(symbol: 'BTCUSDT', threshold: 30000, direction: :up, last_price: 29990, active: true)
      channel = NotificationChannel.create!(name: 'Log', kind: :log)
      alert.notification_channels << channel

      allow_any_instance_of(CheckPricesJob).to receive(:fetch_price).with('BTCUSDT').and_return(BigDecimal('30000'))
      notifier = instance_double(Notifiers::LogNotifier)
      allow(Notifiers::LogNotifier).to receive(:new).and_return(notifier)
      allow(notifier).to receive(:notify)

      perform_enqueued_jobs { described_class.perform_now }

      expect(alert.reload.last_price).to eq(BigDecimal('30000'))
      expect(notifier).to have_received(:notify).with(alert, BigDecimal('30000'))
    end
  end
end
