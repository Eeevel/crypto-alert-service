class NotificationChannel < ApplicationRecord
  has_and_belongs_to_many :alerts

  enum kind: { log: 0, email: 1, browser: 2 }

  def settings=(value)
    parsed = case value
             when String
               begin
                 JSON.parse(value)
               rescue StandardError
                 {}
               end
             when NilClass
               {}
             else
               value
             end
    super(parsed)
  end

  validates :name, presence: true
  validates :kind, presence: true

  validate :validate_settings

  private

  def validate_settings
    case kind&.to_sym
    when :email
      email = settings.is_a?(Hash) ? settings["email"] : nil
      errors.add(:settings, "email is required") if email.blank?
    end
  end
end
