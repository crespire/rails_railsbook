require 'rails_helper'

RSpec.describe User, type: :model do
  context 'given a user with a mix of friends and pending requests' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }
    let(:pending_a) { create(:user) }
    let(:pending_b) { create(:user) }

    context 'when the user is the sender' do
      before do
        create(:request, :accepted, user: user, friend: friend)
        create(:request, user: user, friend: pending_a)
        create(:request, user: user, friend: pending_b)
      end

      it 'returns the right number of users when sent #friends' do
        expect(user.reload.friends.length).to eq(1)
      end

      it 'returns the right number of users when sent #pending_friends' do
        expect(user.reload.pending_friends.length).to eq(2)
      end

      it 'returns the right number of users when sent #all_friends' do
        expect(user.reload.all_friends.length).to eq(3)
      end
    end

    context 'when the user is the receiver' do
      before do
        create(:request, :accepted, user: friend, friend: user)
        create(:request, user: pending_a, friend: user)
        create(:request, user: pending_b, friend: user)
      end

      it 'returns the right number of objects when sent #friends' do
        expect(user.reload.friends.length).to eq(1)
      end

      it 'returns the right number of objects when sent #pending_friends' do
        expect(user.reload.pending_friends.length).to eq(2)
      end

      it 'returns the right number of objects when sent #all_friends' do
        expect(user.reload.all_friends.length).to eq(3)
      end
    end

    context 'when using #find_request' do
      it 'returns nil when passed self' do
        expect(user.find_request(user)).to be_nil
      end

      it 'returns the right request when passed a friend that the user requested' do
        create(:request, :accepted, user: user, friend: friend)
        request = user.find_request(friend)
        expect(request).to be_a(Request)
        expect(request.friend).to eq(friend)
      end

      it 'returns the right request when passed a friend that requested to be friends with the user' do
        create(:request, :accepted, user: friend, friend: user)
        request = user.find_request(friend)
        expect(request).to be_a(Request)
        expect(request.friend).to eq(user)
      end

      it 'returns the right request when passed a pending friend that the user requested' do
        create(:request, user: user, friend: friend)
        request = user.find_request(friend)
        expect(request).to be_a(Request)
        expect(request.accepted).to be_falsey
        expect(request.friend).to eq(friend)
      end

      it 'returns the right request when passed a pending friend that requested the user' do
        create(:request, user: friend, friend: user)
        request = user.find_request(friend)
        expect(request).to be_a(Request)
        expect(request.accepted).to be_falsey
        expect(request.friend).to eq(user)
      end
    end
  end

  context 'when there is content to send #already_liked?' do
    let(:post) { create(:post, :with_comments, comment_count: 1) }
    let(:user) { create(:user) }

    it 'returns true when passed a resource the user has already liked' do
      create(:like, user: user, likeable: post)
      expect(user.already_liked?(post)).to be_truthy
    end

    it 'returns false when passed a resource the user yet to like' do
      expect(user.already_liked?(post)).to be_falsey
    end
  end

  context 'when sent #profile_picture' do
    let(:avatar_only) { create(:user, :with_pic_attached) }
    let(:external_only) { create(:user, :with_external_pic) }
    let(:both) { create(:user, :with_both_pics) }
    let(:default) { create(:user) }

    it 'returns an attached avatar if it exists' do
      expect(avatar_only.profile_picture).to be_a(ActiveStorage::VariantWithRecord)
    end

    it 'returns an attached avatar over an external picture when both exist' do
      expect(both.external_picture).to be_truthy
      expect(avatar_only.profile_picture).to be_a(ActiveStorage::VariantWithRecord)
    end

    it 'returns an external picture if it exists and there is not attached avatar' do
      expect(external_only.profile_picture).to be_a(String)
      expect(external_only.profile_picture).to include('gravatar.com')
    end

    it 'returns the default picture if no other option exists' do
      expect(default.profile_picture).to be_a(String)
      expect(default.profile_picture).to include('default_pic.png')
    end
  end

  it 'sends a welcome email on successful creation' do
    user = build(:user)
    expect(user).to receive(:send_welcome_email)
    user.save
  end
end
