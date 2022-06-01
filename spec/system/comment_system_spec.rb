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

      it 'allows a user to edit their own comment' do
        visit root_path
        find('div.c-post__input').fill_in 'comment_content', with: 'Test Comment'
        click_button 'Add comment'

        find('div.c-post__responses').click_link 'Edit'
        find('div.c-post__responses').fill_in 'comment_content', with: 'Test Comment Edited'
        click_button 'Update'

        expect(page).to have_text('Test Comment Edited')
        expect(current_path).to eq(root_path)
      end

      it 'does not allow a user to update to a blank comment' do
        visit root_path
        find('div.c-post__input').fill_in 'comment_content', with: 'Test Comment'
        click_button 'Add comment'

        find('div.c-post__responses').click_link 'Edit'
        find('div.c-post__responses').fill_in 'comment_content', with: ''
        click_button 'Update'

        message = page.find('div.c-post__responses').find('#comment_content').native.attribute('validationMessage')

        expect(message).to have_text('Please fill in this field.')
        expect(current_path).to eq(root_path)
      end

      it 'allows a user to delete their own comment' do
        visit root_path
        find('div.c-post__input').fill_in 'comment_content', with: 'Test Comment'
        click_button 'Add comment'

        expect(page).to have_text('Test Comment')
        user.reload
        expect(user.comments.size).to eq(1)

        accept_confirm do
          find('p.c-post__actions-comment').click_link 'Delete'
        end

        expect(page).to_not have_text('Test Comment')
        user.reload
        expect(user.comments.size).to eq(0)
      end
    end
  end
end