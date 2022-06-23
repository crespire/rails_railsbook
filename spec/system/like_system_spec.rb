require 'rails_helper'

RSpec.describe 'Likes system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'Allows a user to like other user posts and comments' do
  end

  context 'Allows a user to like their own comments' do
  end

  context 'Correctly deletes likes when the parent resource is deleted' do
  end
end