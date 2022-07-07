require 'rails_helper'

RSpec.describe 'Post system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'when there is no user logged in' do
    it 'redirects the user to authenticate' do
      click_button 'Log Out' if page.has_button?('Log Out')

      visit root_path
      expect(page).to have_text('You need to sign in or sign up before continuing.')
      expect(current_path).to eq(new_user_session_path)
    end
  end

  context 'when a user is logged in' do
    let(:user) { FactoryBot.create(:user) }

    before do
      login_as(user, scope: :user)
    end

    it 'successfully posts a post as a user' do
      create :post

      visit root_path
      find('div.l-new_post').fill_in 'post_content', with: 'Test Post from Capybara'
      click_button 'Post'

      expect(page).to have_text('Test Post from Capybara')
    end

    it 'does not allow submission of an empty post' do
      visit root_path
      click_button 'Post'

      message = page.find('#post_content').native.attribute('validationMessage')

      expect(message).to have_text('Please fill in this field.')
      expect(current_path).to eq(root_path)
    end

    it 'does not allow a user to edit a non-owned post' do
      create(:post)
      expect(page).not_to have_text('Edit')
    end

    it 'allows a user to edit their own post' do
      create(:post, user_id: user.id)

      visit root_path
      click_link 'Edit'
      expect(current_path).to eq(root_path)

      find('div.l-feed').fill_in 'post_content', with: 'Test Post from Capybara with an edit!'
      find('div.l-feed').click_button 'Post'
      expect(page).to have_text('Test Post from Capybara with an edit!')
      expect(current_path).to eq root_path
    end

    it 'allows a user to delete their own post' do
      create(:post, user: user, content: 'Test Delete')
      expect(user.posts.size).to eq(1)

      visit root_path
      expect(page).to have_text('Test Delete')
      accept_confirm do
        find('div.c-post__actions').click_link 'Delete'
      end

      expect(current_path).to eq(root_path)
      expect(page).not_to have_text('Test Delete')
      expect(Post.count).to eq(0)
    end

    it 'allows a user to delete their own post with comments' do
      create(:post, user: user, content: 'Test Delete')
      post = Post.first
      comment = post.comments.build(content: "Test Comment", user_id: user.id)
      comment.save
      expect(user.reload.posts.size).to eq(1)
      expect(user.comments.size).to eq(1)

      visit root_path
      expect(page).to have_text('Test Delete')
      accept_confirm do
        find('div.c-post__actions').click_link 'Delete'
      end

      expect(current_path).to eq(root_path)
      expect(page).not_to have_text('Test Delete')
      expect(Comment.count).to eq(0)
      expect(Post.count).to eq(0)
    end
  end

  context "when deleting a post" do
    it "deletes all child comments as well" do
      post = create(:post, :with_comments, comment_count: 5)
      expect(Comment.count).to eq(5)
      expect { post.destroy }.to change { Comment.count }.by(-5)
    end

    it "deletes all child likes as well" do
      post = create(:post, :with_comments, comment_count: 5)
      5.times { create(:like, likeable: post) }
      expect(Like.count).to eq(5)
      expect { post.destroy }.to change { Like.count }.by(-5)
    end
  end
end
