require 'rails_helper'

RSpec.describe Notifiable do
  context 'when the resource is a like' do
    let(:post) { create(:post) }
    let(:like) { create(:like, likeable: post) }

    it 'correctly notifies the resource owner' do
      expect { like.notify }.to change { Notification.count }.by(1)
      expect(Notification.first.target).to eq(post.user)
    end
  end

  context 'when the resource is a comment' do
    let(:post) { create(:post) }
    let(:comment) { create(:comment, post: post) }

    it 'correctly notifies the post owner' do
      expect { comment.notify }.to change { Notification.count }.by(1)
      expect(Notification.first.target).to eq(post.user)
    end
  end

  context 'when the resource is a request' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let(:request) { create(:request, user: user_a, friend: user_b) }

    it 'correctly notifies the target user' do
      expect { request.notify }.to change { Notification.count }.by(1)
      expect(Notification.first.target).to eq(user_b)
    end
  end
end
