require 'rails_helper'

RSpec.describe User, type: :model do
  context 'given a user with a mix of friends and pending requests' do
    it 'returns the right number of objects when sent #friends'
  
    it 'returns the right number of objects when sent #pending_friends'
  
    it 'returns the right number of objects when sent #all_friends'
  
    it 'returns the right number of objects when sent #all_requests'
  
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
