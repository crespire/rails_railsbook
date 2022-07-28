require 'rails_helper'

RSpec.describe 'Likes system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
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

        find('div.c-post__content', text: post_self.content.body.to_plain_text).sibling('div.c-post__status').click_link('Like')

        expect(page).to have_text('Likes: 1')
        expect(post_self.reload.likes.size).to eq(1)
        expect(Like.count).to eq(1)
      end

      it "allows a user to like another user's post" do
        post = create(:post)
        expect(Like.count).to eq(0)
        expect(post.likes.size).to eq(0)

        login_as(user1)
        visit root_path

        find('div.c-post__content').sibling('div.c-post__status').click_link('Like')

        expect(page).to have_text('Likes: 1')
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

        like_panel = find('div.c-post__content', text: post_self.content.body.to_plain_text).sibling('div.c-post__status')
        expect(like_panel).to have_text('Unlike')
      end

      it 'allows a user to remove their like on their own post' do
        post_self = user1.posts.first
        create(:like, likeable: post_self, user: user1)
        expect(post_self.likes.size).to eq(1)

        login_as(user1, scope: :user)
        visit root_path

        find('div.c-post__content', text: post_self.content.body.to_plain_text).sibling('div.c-post__status').click_link('Unlike')

        expect(page).to have_text('Likes: 0')
        expect(post_self.reload.likes.size).to eq(0)
        expect(Like.count).to eq(0)
      end

      it "allows a user to remove their like on another user's post" do
        login_as(user1, scope: :user)
        visit root_path

        find('div.c-post__status').click_link('Like')
        expect(page).to have_text('Likes: 1')
        expect(Like.count).to eq(1)

        find('div.c-post__status').click_link('Unlike')

        expect(page).to have_text('Likes: 0')
        expect(post.reload.likes.size).to eq(0)
        expect(Like.count).to eq(0)
      end
    end
  end

  context 'where there are comments by two users' do
    # Creates 3 users, 2 posts and 2 comments.
    # User1 with post and comment
    # User2 with post
    # User3 with comment on User2's post.
    let!(:user1) { create(:user, :with_posts, post_count: 1) }
    let!(:post) { create(:post) }
    let!(:comment) { create(:comment, post: post) }
    let!(:comment_self) { create(:comment, post: post, user: user1) }

    before(:each) do
      # Users have to be friends to see each other's content.
      users = User.all
      users.each do |user|
        next if user == user1

        create(:request, :accepted, user: user1, friend: user)
      end
    end

    context 'where a user has not liked any content' do
      it 'allows a user to like their own comments' do
        login_as(user1, scope: :user)
        visit root_path

        find('div.c-comment__content', text: comment_self.content.body.to_plain_text).sibling('div.c-comment__status').click_link('Like')

        expect(page).to have_text('Likes: 1')
        expect(comment_self.reload.likes.size).to eq(1)
        expect(Like.count).to eq(1)
      end

      it "allows a user to like another user's comment" do
        login_as(user1, scope: :user)
        visit root_path

        find('div.c-comment__content', text: comment.content.body.to_plain_text).sibling('div.c-comment__status').click_link('Like')

        expect(page).to have_text('Likes: 1')
        expect(comment.reload.likes.size).to eq(1)
        expect(Like.count).to eq(1)
      end
    end

    context 'where a user has already liked some content' do
      it 'allows a user to remove their like on their own comments' do
        create(:like, likeable: comment_self, user: user1)
        expect(comment_self.likes.size).to eq(1)

        login_as(user1, scope: :user)
        visit root_path

        element = find('div.c-comment__content', text: comment_self.content.body.to_plain_text).sibling('div.c-comment__status')
        element.click_link('Unlike')

        expect(element).to have_text('Likes: 0')
        expect(comment_self.reload.likes.size).to eq(0)
      end

      it "allows a user to remove their like on another user comment" do
        create(:like, likeable: comment, user: user1)
        expect(comment.likes.size).to eq(1)

        login_as(user1, scope: :user)
        visit root_path

        element = find('div.c-comment__content', text: comment.content.body.to_plain_text).sibling('div.c-comment__status')
        element.click_link('Unlike')

        expect(element).to have_text('Likes: 0')
        expect(comment.reload.likes.size).to eq(0)
      end
    end
  end

  context 'correctly deletes likes when the parent resource is deleted' do
    let!(:user1) { create(:user, :with_posts, post_count: 1) }

    it 'correctly deletes a like on a child comment when the post is deleted' do
      post = user1.posts.first
      create(:comment, post: post, user: user1)
      expect(post.comments.size).to eq(1)
      comment = post.comments.first

      create(:like, likeable: comment, user: user1)
      expect(comment.reload.likes.size).to eq(1)

      expect { post.destroy }.to change { Like.count }.from(1).to(0)
    end
  end
end
