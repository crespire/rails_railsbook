require 'rails_helper'

RSpec.describe 'Post system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'when there is no user logged in' do
    it 'redirects the user to authenticate' do
      visit root_path
      expect(page).to have_text('You need to sign in or sign up before continuing.')
      expect(current_path).to eq(new_user_session_path)
    end
  end

  context 'when a user is logged in' do
    let(:user) { FactoryBot.create(:user) }

    it 'successfully posts a post as a user' do
      login_as(user, scope: :user)
      create :post

      visit root_path
      fill_in 'post_content', with: 'Test Post from Capybara'
      click_button 'Post'

      expect(page).to have_text('Test Post from Capybara')
    end

    it 'does not allow submission of an empty post' do
      login_as(user, scope: :user)

      visit root_path
      click_button 'Post'

      message = page.find('#post_content').native.attribute('validationMessage')

      expect(message).to have_text('Please fill in this field.')
      expect(current_path).to eq(root_path)
    end

    it "does not allow a user to edit a non-owned post" do
      login_as(user)
      FactoryBot.create(:post)
      expect(page).not_to have_text('Edit')
    end

    it 'allows a user to edit their own post' do
      login_as(user, scope: :user)
      FactoryBot.create(:post, user_id: user.id)

      visit root_path
      click_link 'Edit'
      expect(current_path).to eq(root_path)

      fill_in 'post_content', with: 'Test Post from Capybara with an edit!'
      click_button 'Post'
      expect(page).to have_text('Test Post from Capybara with an edit!')
      expect(current_path).to eq root_path
    end
  end
end
