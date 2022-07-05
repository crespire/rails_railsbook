class Comment < ApplicationRecord
  after_create :notify
  after_destroy :remove_notify

  belongs_to :post, counter_cache: true
  belongs_to :user, counter_cache: true

  has_many :likes, as: :likeable, dependent: :destroy

  validates :content, presence: true

  private

  def notify
    parent = Post.find(post.id)
    message = "#{user.name} added a comment to your post."
    Notification.create(user_id: parent.user.id, trigger_type: 'Comment', trigger_id: id, triggered_by_id: user.id, message: message)
  end

  def remove_notify
    parent = Post.find(post.id)
    return unless Notification.where(id: id, trigger_type: 'Comment', trigger_id: id, user_id: parent.user.id).exists?

    Notification.destroy_by(id: id, trigger_type: 'Comment', trigger_id: id, user_id: parent.user.id)
  end
end
