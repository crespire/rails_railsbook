class Request < ApplicationRecord
  after_create :notify
  after_destroy :remove_notify

  belongs_to :user
  belongs_to :friend, class_name: :User

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :user_id, uniqueness: { scope: [:friend_id] }

  scope :accepted, -> { where('accepted = true') }
  scope :pending, -> { where('accepted = false') }

  def accept_request
    self.accepted = true
    self.save
  end

  private

  def notify
    message = "#{user.name} sent you a friend request."
    Notification.create(user_id: friend.id, trigger_type: 'Request', trigger_id: id, triggered_by_id: user.id, message: message)
  end

  def remove_notify
    return unless Notification.where(id: id, trigger_type: 'Request', trigger_id: id, user_id: friend.id).exists?

    Notification.destroy_by(id: id, trigger_type: 'Request', trigger_id: id, user_id: friend.id)
  end
end
