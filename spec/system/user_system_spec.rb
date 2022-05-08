require 'rails_helper'

RSpec.describe 'User system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it 'registers a user when provided with good information' do
    visit new_user_registration

    fill_in 'email', with: 'test0@test.com'
    fill_in 'name', with: 'test0'
    fill_in 'password', with: 'password'
    fill_in 'password confirmation', with: 'password'
    click_button 'Sign Up'

    expect(page).to have_text('User was successfully created.')
  end
end
