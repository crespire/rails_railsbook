require 'rails_helper'

RSpec.describe 'Request/friend system', type: :system do
  let!(:user_a) { FactoryBot.create(:user, name: 'Ken') }
  let!(:user_b) { FactoryBot.create(:user, name: 'Bob') }

  before do
    driven_by(:selenium_chrome_headless)
    13.times { |i| FactoryBot.create(:user, name: "Susan #{i}") }
  end

  context 'when generating a request' do
    before(:each) do
      login_as(user_a, scope: :user)
      visit root_path
      find('input#query').fill_in with: 'Bob'
      click_button 'Search'
      first('li').click_link('Send request')
    end

    it "updates all users' pending requests counts" do
      expect(page).to have_text('Request sent!').once
      expect(user_a.sent_requests.count).to eq(1)
      expect(user_b.received_requests.count).to eq(1)
    end

    it 'does not allow a user to send a request to self' do
      find('input#query').fill_in with: user_a.name
      click_button 'Search'
      expect(page).not_to have_text('Send request')
    end
  end

  context 'while a request is pending' do
    before(:each) do
      login_as(user_a, scope: :user)
      visit root_path
      find('input#query').fill_in with: 'Bob'
      click_button 'Search'
      first('li').click_link('Send request')
    end

    it 'allows the sending user to delete a pending request' do
      visit user_requests_path(user_a)

      expect(page).to have_text('Request sent to')
      page.accept_alert do
        find('li', text: 'Request sent to Bob').click_link('Delete')
      end
      expect(page).to have_text('Deleted!')
      expect(user_a.sent_requests.count).to eq(0)
    end

    it 'allows receiving user to accept a pending request' do
      login_as(user_b, scope: :user)
      visit user_requests_path(user_b)

      expect(page).to have_text('Request received from')
      find('li', text: 'Request received from').click_link('Accept')
      expect(page).to have_text('Accepted!')
    end
  end

  context 'after an accepted request' do
    before(:each) do
      login_as(user_a, scope: :user)
      visit root_path
      find('input#query').fill_in with: 'Bob'
      click_button 'Search'
      first('li').click_link('Send request')
      login_as(user_b, scope: :user)
      visit user_requests_path(user_b)
      find('li', text: 'Request received from').click_link('Accept')
    end

    it 'allows the sending user to delete an accepted request' do
      expect(user_a.reload.friends.count).to eq(1)
      expect(user_b.reload.friends.count).to eq(1)

      login_as(user_a, scope: :user)
      visit user_path(user_a)
      page.accept_alert do
        first('li').click_link('Delete?')
      end
      expect(page).to have_text('Deleted!')
      expect(user_a.reload.friends.count).to eq(0)
    end

    it 'allows the receiving user to delete an accepted request' do
      expect(user_a.reload.friends.count).to eq(1)
      expect(user_b.reload.friends.count).to eq(1)

      login_as(user_b, scope: :user)
      visit user_path(user_b)
      page.accept_alert do
        first('li').click_link('Delete?')
      end
      expect(page).to have_text('Deleted!')
      expect(user_b.reload.friends.count).to eq(0)
    end
  end
end