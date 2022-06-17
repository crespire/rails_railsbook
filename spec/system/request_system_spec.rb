require 'rails_helper'

RSpec.describe 'Request/friend system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'For a user initiating requests' do
    let!(:user_a) { FactoryBot.create(:user) }
    let!(:user_b) { FactoryBot.create(:user, name: 'Bob') }

    before do
      13.times { |i| FactoryBot.create(:user, name: "Susan #{i}") }
    end

    it "updates all users' pending requests counts" do
      login_as(user_a, scope: :user)
      visit root_path
      find('input#query').fill_in with: 'Bob'
      click_button 'Search'

      expect(page).to have_text('Send request').once
      first('li').click_link('Send request')
      expect(page).to have_text('Request sent!').once
      expect(user_a.sent_requests.count).to eq(1)
      expect(user_b.received_requests.count).to eq(1)
    end

    it 'allows a user to delete a pending request' do
      login_as(user_a, scope: :user)
      visit root_path
      find('input#query').fill_in with: 'Bob'
      click_button 'Search'
      expect(page).to have_text('Bob').once
      first('li').click_link('Send request')
      expect(user_a.sent_requests.count).to eq(1)

      click_link 'Requests'
      expect(page).to have_text('Request sent to')
      page.accept_alert do
        find('li', text: 'Request sent to Bob').click_link('Delete')
      end
      expect(page).to have_text('Deleted!')
      expect(user_a.sent_requests.count).to eq(0)
    end

    xit 'shows a user pending requests to be accepted' do
    end

    xit 'allows a user to accept a pending, received request' do
    end
    
    xit 'allows a user to delete an accepted request' do
    end

    xit 'does not allow a user to send a request to self' do
      # log in as user, search for self, should not be accept button
    end
  end
end