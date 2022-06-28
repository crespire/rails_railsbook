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

    expect(page).to have_text('Hello, test0!')
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

  context 'when deleting a user' do
    let!(:user) { FactoryBot.create(:user, :with_posts, post_count: 5) }
    let!(:user2) { FactoryBot.create(:user, :with_posts, post_count: 5) }
    
    it 'deletes a user successfully' do
      # log in, click button, check users in db
    end

    it "deletes a user's posts as well" do
      # just do this bit in the database, because the only view is to delete your own account
      using_session(:user) do
        login_as(user, scope: :user)
        expect(user.posts.length).to eq(5)
        expect(Post.count).to eq(10)

        visit user_path(user)
        accept_confirm { click_button 'Delete my account.' }
        expect(Post.count).to eq(5)
      end
    end

    it "deletes a user's comments as well" do
      post = user2.posts.first
      create(:comment, post: post, user: user)

      expect(user.comments.length).to eq(1)
      expect(Comment.count).to eq(1)

      expect { user.destroy }.to change { Comment.count }.from(1).to(0)
    end

    it "deletes a user's likes as well" do
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
