require 'rails_helper'

RSpec.describe 'User search', type: :request do
  describe 'Exact match search' do
    let(:searching_user) { FactoryBot.create(:user) }

    before do
      5.times { FactoryBot.create(:user) }
      login_as(searching_user, scope: :user)
    end

    it 'returns a user when given the exact name' do
      user = User.find(User.pluck(:id).sample)
      get "/search?query=#{user.name}&commit=Search"
      expect(response.body).to include(user.name)
    end
  end

  describe 'Partial match search' do
    let(:search_user) { FactoryBot.create(:user) }

    before do
      FactoryBot.create(:user, name: 'Bob')
      FactoryBot.create(:user, name: 'Bobby')
      FactoryBot.create(:user, name: 'Susan')
      login_as(search_user, scope: :user)
    end

    it 'returns all partial matches' do
      get '/search?query=Bob&commit=Search'
      expect(response.body).to include('Bob').at_least(2).times
    end
  end
end