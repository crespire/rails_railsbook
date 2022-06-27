require 'rails_helper'

RSpec.describe 'Likes system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'where there are posts by two users' do
    let!(:user1) { FactoryBot.create(:user, :with_posts, post_count: 1) }
    let!(:post) { FactoryBot.create(:post) }

    context 'where one user does not have any likes' do
      it 'allows a user to like their own posts' do
        post = create(:post, user: user1)
        expect(post.likes.size).to eq(0)
        create(:like, likeable: post, user: user1) # lol I have to create these likes via clicks
      end

      it "allows a user to like another user's post" do
        expect(post.likes.size).to eq(0)
        create(:like, likeable: post, user: user1)
      end

      after(:each) do
        expect(Like.count).to eq(1)
        expect(user1.likes_count).to eq(1)
      end
    end

    context 'where one user has liked some content' do
      let!(:user1) { FactoryBot.create(:user) }
      let!(:comment) { FactoryBot.create(:comment) }

      before(:each) do
        create(:like, likeable: comment, user: user1)
      end

      xit 'allows a user to remove their like on their own post' do
      end

      xit "allows a user to remove their like on another user's post" do
      end
    end
  end

  xcontext 'where there are comments by two users' do

    context 'where a user has not liked any content' do
      it 'allows a user to like their own comments' do
      end

      it "allows a user to like another user's comment" do
      end
    end

    context 'where a user has already liked some content' do
      it 'allows a user to remove their like on their own comments' do
      end

      it "allows a user to remove their own like on another user's comment" do
      end
    end
  end

  xcontext 'Correctly deletes likes when the parent resource is deleted' do
  end
end
