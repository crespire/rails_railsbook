require 'rails_helper'

RSpec.describe Notifiable do
  context 'when the resource is a like' do
    let(:post) { create(:post) }
    let(:test_resource) { create(:like, likeable: post) }

    it 'correctly notifies the resource owner' do
      expect { test_resource.notify }.to change { Notification.count }.by(1)
      expect(Notification.first.target).to eq(post.user)
    end
  end

  context 'when the resource is a comment' do
    let(:post) { create(:post) }
    let(:test_resource) { create(:comment, post: post) }

    it 'correctly notifies the post owner' do
      expect { test_resource.notify }.to change { Notification.count }.by(1)
      expect(Notification.first.target).to eq(post.user)
    end
  end

  context 'when the resource is a request' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let(:test_resource) { create(:request, user: user_a, friend: user_b) }

    it 'correctly notifies the target user' do
      expect { test_resource.notify }.to change { Notification.count }.by(1)
      expect(Notification.first.target).to eq(user_b)
    end
  end
end
