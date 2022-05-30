require 'rails_helper'

RSpec.describe 'Comment system', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'when a user is logged in' do
    let(:user) { FactoryBot.create(:user) }

    before do
      login_as user, scope: :user
    end

    context 'with a post from another user' do

      before do
        create :post
      end

      it 'allows a user to comment on the post' do
        visit root_path
        find('div.c-post__input').fill_in 'comment_content', with: 'Test Comment'
        click_button 'Add comment'

        expect(page).to have_text('Test Comment')
      end

      it 'does not allow a user to submit a blank comment' do
        visit root_path
        find('div.c-post__input').click_button 'Add comment'
        message = page.find('#comment_content').native.attribute('validationMessage')

        expect(message).to have_text('Please fill in this field.')
        expect(current_path).to eq(root_path)
      end

      xit 'allows a user to edit their own comment' do
      end
  
      xit 'does not allow a user to update to a blank comment' do
      end
  
      xit 'does not allow a user to edit another users comment' do
      end
  
      xit 'allows a user to delete their own comment' do
      end
    end
  end
end