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
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_text('Hello, test0!')
    expect(page).to have_text('You have signed up successfully.')
    expect(User.count).to eq(1)
  end

  it 'does not allow a user to register with a blank email' do
    visit '/users/sign_up'

    fill_in 'Name', with: 'test0'
    fill_in 'Password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
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
    fill_in 'user_password_confirmation', with: 'password'
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
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_text('Email has already been taken')
  end

  context 'when deleting a user' do
    let!(:user) { FactoryBot.create(:user, :with_posts, post_count: 5) }
    let!(:user2) { FactoryBot.create(:user, :with_posts, post_count: 5) }

    it 'deletes a user successfully' do
      login_as(user, scope: :user)
      visit edit_user_registration_path(user)
      accept_confirm { click_button 'Delete my account.' }
      expect(page).to have_text('Account deleted.')
      expect(User.count).to eq(1)
    end

    it 'deletes their posts as well' do
      login_as(user, scope: :user)
      expect(user.posts.length).to eq(5)
      expect(Post.count).to eq(10)

      visit edit_user_registration_path(user)
      accept_confirm { click_button 'Delete my account.' }
      expect(page).to have_text('Account deleted.')
      expect(Post.count).to eq(5)
    end

    context 'deletes requests' do
      before do
        login_as(user)
        visit user_path(user2.id)
        click_link('Send request')
        expect(page).to have_text('Request sent!')
        visit root_path
        expect(Request.count).to eq(1)
      end

      it 'sent by the deleted user' do
        login_as(user)
        visit edit_user_registration_path(user)
        accept_confirm { click_button 'Delete my account.' }
        expect(page).to have_text('Account deleted.')
        expect(Request.count).to eq(0)
      end

      it 'recieved by the deleted user' do
        login_as(user2)
        visit edit_user_registration_path(user2)
        accept_confirm { click_button 'Delete my account.' }
        expect(page).to have_text('Account deleted.')
        expect(Request.count).to eq(0)
      end
    end

    it "deletes their comments as well" do
      post = user2.posts.first
      create(:comment, post: post, user: user)

      expect(user.comments.length).to eq(1)
      expect(Comment.count).to eq(1)

      expect { user.destroy }.to change { Comment.count }.from(1).to(0)
    end

    it "deletes their likes as well" do
      post = user2.posts.first
      create(:like, likeable: post, user: user)

      expect(user.likes.length).to eq(1)
      expect(post.likes.length).to eq(1)
      expect(Like.count).to eq(1)

      expect { user.destroy }.to change { Like.count }.from(1).to(0)
      post.reload
      expect(post.likes.length).to eq(0)
    end
  end
end
