module Notifiers
  class BaseNotifier
    def initialize(channel)
      @channel = channel
    end

    def notify(_alert, _current_price)
      raise NotImplementedError
    end

    private

    attr_reader :channel
  end
end
