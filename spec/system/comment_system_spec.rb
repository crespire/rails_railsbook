equire 'rails_helper'

RSpec.describe 'Comment system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end
end