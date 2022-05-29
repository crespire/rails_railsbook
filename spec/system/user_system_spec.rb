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

    message = page.find('#user_email').native.attribute('validationMessage')

    expect(message).to have_text('Please fill in this field.')
    expect(current_path).to eq new_user_registration_path
  end

  it 'does not allow a user to register with a malformed email' do
    visit '/users/sign_up'

    fill_in 'Email', with: 'testbademail.com'
    fill_in 'Name', with: 'test0'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    message = page.find('#user_email').native.attribute('validationMessage')

    expect(message).to have_text('Please include')
    expect(current_path).to eq new_user_registration_path
  end

  it 'does not allow a user to register with an email that is already used' do
    user = FactoryBot.create(:user)

    visit '/users/sign_up'
    fill_in 'Email', with: user.email
    fill_in 'Name', with: 'Fake user'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_text('Email has already been taken')
  end

  it 'deletes a user with posts and comments' do
    # stub - I wonder if this test wouldn't be better done in a controller spec.
  end
end
