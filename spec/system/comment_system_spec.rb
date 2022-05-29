equire 'rails_helper'

RSpec.describe 'Comment system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'when a user is logged in' do
    it 'allows a user to comment on their own post' do
    end

    it 'does not allow a user to submit a blank comment' do
    end

    it "allows a user to comment on another user's post" do
    end

    it 'allows a user to edit their own comment' do
    end

    it 'does not allow a user to update to a blank comment' do
    end

    it 'does not allow a user to edit another users comment' do
    end

    it 'allows a user to delete their own comment' do
    end
  end
end