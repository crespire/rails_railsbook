require 'rails_helper'

RSpec.describe 'Notifications spec', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'when commenting' do
    let(:user) { FactoryBot.create(:user) }

    before do
      login_as user, scope: :user
      create :post
    end

    it 'the correct notification is created' do
      visit root_path
      find('div.c-post__input').fill_in 'comment_content', with: 'Test Comment'
      click_button 'Add comment'

      expect(page).to have_text('Test Comment')
      expect(Notification.count).to eq(1)

      notify = Notification.first
      expect(notify.actor).to eq(user)
      expect(notify.target).to eq(Post.first.user)
      expect(notify.message).to include('commented')
    end
  end

  context 'when liking' do
    let!(:user_a) { FactoryBot.create(:user, :with_posts, post_count: 1) }
    let!(:user_b) { create(:user) }

    it 'the correct notification is created' do
      login_as(user_b)
      visit root_path

      find('div.c-post__content', text: user_a.posts.first.content).sibling('div.c-post__status').click_link('Like')

      expect(page).to have_text('Likes: 1')
      expect(Notification.count).to eq(1)

      notify = Notification.first
      expect(notify.actor).to eq(user_b)
      expect(notify.target).to eq(user_a)
      expect(notify.message).to include('liked')
    end
  end

  context 'when sending a request' do
    let!(:user_a) { FactoryBot.create(:user, name: 'Ken') }
    let!(:user_b) { FactoryBot.create(:user, name: 'Bob') }

    it 'the correct notification is created' do
      login_as(user_a)
      visit root_path
      find('input#query').fill_in with: 'Bob'
      click_button 'Search'
      first('li').click_link('Send request')

      expect(page).to have_text('Request sent!')
      expect(Notification.count).to eq(1)

      notify = Notification.first
      expect(notify.actor).to eq(user_a)
      expect(notify.target).to eq(user_b)
      expect(notify.message).to include('sent you a friend request')
    end
  end
end
