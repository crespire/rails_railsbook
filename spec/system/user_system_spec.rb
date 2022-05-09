require 'rails_helper'

RSpec.describe 'User system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it 'registers a user when provided with good information' do
    visit '/users/sign_up'

    fill_in 'Email', with: 'test0@test.com'
    fill_in 'Name', with: 'test0'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_text('Hello test0.')
    expect(page).to have_text('You have signed up successfully.')
    expect(User.count).to eq(1)
  end

  it 'does not allow a user to register with a blank email' do
    visit '/users/sign_up'

    fill_in 'Name', with: 'test0'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_text('errors prohibited')
  end
end
