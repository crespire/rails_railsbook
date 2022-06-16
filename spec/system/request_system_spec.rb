require 'rails_helper'

RSpec.describe 'Request/friend system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'For a user initiating requests' do
    it "updates the user's pending requests count" do
    end

    it "updates the target user's received requests" do
    end

    it 'allows a user to delete a pending request' do
    end
    
    it 'allows a user to delete an accepted request' do
    end
  end
end