require 'rails_helper'

RSpec.shared_examples 'creates a new notification' do
  it 'increments the number of notifications by 1' do
    expect { perform }.to change { Notification.count }.by(1)
  end
end