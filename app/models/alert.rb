class Alert < ApplicationRecord
  has_and_belongs_to_many :notification_channels

  enum direction: { down: 0, up: 1 }

  before_validation :normalize_symbol

  validates :symbol, presence: true, format: { with: /\A[A-Z]{3,}USDT\z/, message: "must be a Binance symbol ending with USDT (e.g., BTCUSDT)" }
  validates :threshold, presence: true, numericality: { greater_than: 0 }
  validates :direction, presence: true

  scope :active, -> { where(active: true) }

  def crossed?(current_price)
    return false if current_price.nil?

    if last_price.nil?
      return false
    end

    if up?
      last_price < threshold && current_price >= threshold
    else
      last_price > threshold && current_price <= threshold
    end
  end

  private

  def normalize_symbol
    return if symbol.blank?
    s = symbol.to_s.strip.upcase
    s += "USDT" unless s.end_with?("USDT")
    self.symbol = s
  end
end
