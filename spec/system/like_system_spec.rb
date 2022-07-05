require 'rails_helper'

RSpec.describe 'Likes system', type: :system do
  before do
    driven_by(:selenium_chrome)
  end

  context 'where there are posts by two users' do
    let!(:user1) { FactoryBot.create(:user, :with_posts, post_count: 1) }

    context 'where one user does not have any likes' do
      it 'allows a user to like their own posts' do
        post_self = user1.posts.first
        expect(Like.count).to eq(0)
        expect(post_self.likes.size).to eq(0)

        login_as(user1)
        visit root_path

        find('div.c-post__content', text: post_self.content).sibling('div.c-post__status').click_link('Like')

        expect(page).to have_text('Likes: 1')
        expect(post_self.reload.likes.size).to eq(1)
        expect(Like.count).to eq(1)
      end

      it "allows a user to like another user's post" do
        post = create(:post, content: 'Capybara Test Post')
        expect(Like.count).to eq(0)
        expect(post.likes.size).to eq(0)

        login_as(user1)
        visit root_path

        find('div.c-post__content', text: 'Capybara Test Post').sibling('div.c-post__status').click_link('Like')

        expect(page).to have_text('Likes: 1')
        expect(post.reload.likes.size).to eq(1)
        expect(Like.count).to eq(1)
      end
    end

    context 'where one user has liked some content' do
      let!(:user1) { FactoryBot.create(:user, :with_posts, post_count: 1) }
      let!(:post) { FactoryBot.create(:post) }

      it 'does not allow a user to like something more than once' do
        post_self = user1.posts.first
        create(:like, likeable: post_self, user: user1)
        expect(post_self.likes.size).to eq(1)

        login_as(user1, scope: :user)
        visit root_path

        like_panel = find('div.c-post__content', text: post_self.content).sibling('div.c-post__status')
        expect(like_panel).to have_text('Unlike')
      end

      it 'allows a user to remove their like on their own post' do
        post_self = user1.posts.first
        create(:like, likeable: post_self, user: user1)
        expect(post_self.likes.size).to eq(1)

        login_as(user1, scope: :user)
        visit root_path

        find('div.c-post__content', text: post_self.content).sibling('div.c-post__status').click_link('Unlike')

        expect(page).to have_text('Likes: 0')
        expect(post_self.reload.likes.size).to eq(0)
        expect(Like.count).to eq(0)
      end

      it "allows a user to remove their like on another user's post" do
        create(:like, likeable: post, user: user1)
        expect(post.likes.size).to eq(1)

        login_as(user1, scope: :user)
        visit root_path

        find('div.c-post__content', text: post.content).sibling('div.c-post__status').click_link('Unlike')

        expect(page).to have_text('Likes: 0')
        expect(post.reload.likes.size).to eq(0)
        expect(Like.count).to eq(0)
      end
    end
  end

  context 'where there are comments by two users' do
    context 'where a user has not liked any content' do
      it 'allows a user to like their own comments' do
      end

      xit "allows a user to like another user's comment" do
      end
    end

    xcontext 'where a user has already liked some content' do
      it 'allows a user to remove their like on their own comments' do
      end

      it "allows a user to remove their own like on another user's comment" do
      end
    end
  end

  xcontext 'Correctly deletes likes when the parent resource is deleted' do
  end
end
