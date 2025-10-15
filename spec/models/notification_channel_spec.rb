require 'rails_helper'

RSpec.describe NotificationChannel, type: :model do
  it 'parses JSON string settings into a hash' do
    ch = described_class.new(name: 'Email', kind: :email, settings: '{"email":"user@example.com"}')
    expect(ch.settings).to eq({"email"=>"user@example.com"})
    expect(ch).to be_valid
  end

  it 'validates email presence for email kind' do
    ch = described_class.new(name: 'Email', kind: :email, settings: '{}')
    ch.validate
    expect(ch.errors[:settings]).to include("email is required")
  end

  it 'allows log kind with empty settings' do
    ch = described_class.new(name: 'Log', kind: :log)
    expect(ch).to be_valid
  end
end
