require 'rails_helper'

RSpec.describe 'Likes system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'where there are posts by different users' do
    let!(:user1) { FactoryBot.create(:user_with_posts) }
    let!(:user2) { FactoryBot.create(:user_with_posts) }

    it 'allows a user to like their own posts' do
    end

    it 'allows a user to remove their like on their own post' do
    end

    it "allows a user to like another user's post" do
    end

    it "allows a user to remove their like on another user's post" do
    end
  end

  context 'where there are comments by different users' do
    it 'allows a user to like their own comments' do
    end

    it 'allows a user to remove their like on their own comments' do
    end

    it "allows a user to like another user's comment" do
    end

    it "allows a user to remove their own like on another user's comment" do
    end
  end

  context 'Correctly deletes likes when the parent resource is deleted' do
  end
end