require 'rails_helper'

RSpec.describe 'Post system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'when there is no user logged in' do
    it 'redirects the user to authenticate' do
      visit root_path
      # expect(page).to have_text('You need to sign in or sign up before continuing.')
      expect(current_path).to eq(new_user_session_path)
    end
  end

  context 'when a user is logged in' do
    let(:user) { FactoryBot.create(:user) }

    it 'successfully posts a post as a user' do
      login_as(user, scope: :user)

      visit root_path
      fill_in 'post_content', with: 'Test Post from Capybara'
      click_button 'Post'

      expect(page).to have_text('Test Post from Capybara')
    end
  end
end
