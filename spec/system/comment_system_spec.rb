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
        create(:post)
        post_owner = Post.first.user
        create(:request, :accepted, user: user, friend: post_owner)
      end

      it 'allows a user to comment on the post' do
        visit root_path
        find(:xpath, '//*[@id="comment_content"]').set('Test Comment')
        click_button 'Add comment'

        expect(page).to have_text('Test Comment')
      end

      it 'does not allow a user to submit a blank comment' do
        visit root_path
        find('div.c-post__input').click_button 'Add comment'

        expect(page).to have_text('content can not be blank.')
        expect(current_path).to eq(root_path)
      end

      it 'allows a user to edit their own comment' do
        visit root_path
        find(:xpath, '//*[@id="comment_content"]').set('Test Comment')
        click_button 'Add comment'

        find('div.c-post__responses').click_link 'Edit'
        expect(current_path).to eq(root_path)
        find(:xpath, '//div[@class="c-comment__content"]//trix-editor[@id="comment_content"]', match: :first).set('Test Comment Edited')
        click_button 'Update'

        expect(page).to have_text('Test Comment Edited')
        expect(current_path).to eq(root_path)
      end

      it 'does not allow a user to update to a blank comment' do
        visit root_path
        find(:xpath, '//*[@id="comment_content"]').set('Test Comment')
        click_button 'Add comment'

        find('div.c-comment__actions').click_link 'Edit'
        expect(current_path).to eq(root_path)
        find(:xpath, '//div[@class="c-comment__content"]//trix-editor[@id="comment_content"]', match: :first).click.send_keys [:control, 'a'], :delete
        click_button 'Update'

        expect(page).to have_text('content can not be blank.')
        expect(current_path).to eq(root_path)
      end

      it 'allows a user to delete their own comment' do
        visit root_path
        find(:xpath, '//*[@id="comment_content"]').set('Test Comment')
        click_button 'Add comment'

        expect(page).to have_text('Test Comment')
        user.reload
        expect(user.comments.size).to eq(1)

        accept_confirm do
          find('div.c-comment__actions').click_link 'Delete'
        end

        expect(page).to_not have_text('Test Comment')
        user.reload
        expect(user.comments.size).to eq(0)
      end
    end
  end

  context "when deleting a comment" do
    let!(:comment) { create(:comment) }

    it "deletes child likes as well" do
      create(:like, likeable: comment)
      expect(comment.reload.likes.size).to eq(1)
      comment.destroy
      expect(Like.count).to eq(0)
    end
  end
end