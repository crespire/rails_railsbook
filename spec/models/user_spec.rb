require 'rails_helper'

RSpec.describe User, type: :model do
  context 'given a user with a mix of friends and pending requests' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }
    let(:pending) { create(:user) }

    context 'when the user is the sender' do
      it 'returns the right number of objects when sent #friends' do
        create(:request, :accepted, user: user, friend: friend)
        create(:request, user: user, friend: pending)
        expect(user.reload.friends.length).to eq(1)
      end
    
      it 'returns the right number of objects when sent #pending_friends' do
        create(:request, :accepted, user: user, friend: friend)
        create(:request, user: user, friend: pending)
        expect(user.reload.pending_friends.length).to eq(1)
      end
    
      it 'returns the right number of objects when sent #all_friends'
    end

    context 'when the user is the receiver' do
      it 'returns the right number of objects when sent #friends'
    
      it 'returns the right number of objects when sent #pending_friends'
    
      it 'returns the right number of objects when sent #all_friends'
    
      it 'returns the right number of objects when sent #all_requests'
    end
  
    context 'when using #find_request' do
      it 'returns nil when passed self'
  
      it 'returns a request when passed a friend that we friended'
  
      it 'returns a request when passed a friend that requested friendship'
    end
  end

  context 'when there is content to send #already_liked?' do
    it 'returns true when passed a resource the user has already liked'

    it 'returns false when passed a resource the user has already liked'
  end

  context 'when sent #profile_picture' do
    it 'returns an attached avatar if it exists'

    it 'returns an attached avater over an external picture when both exist'

    it 'returns an external picture if it exists and there is not attached avatar'

    it 'returns the default picture if no other option exists'
  end
end
