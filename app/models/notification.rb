class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :target, class_name: 'User', counter_cache: true
  belongs_to :actor, class_name: 'User'

  validates :target_id, presence: true
  validates :notifiable_type, presence: true
  validates :notifiable_id, presence: true
  validates :message, presence: true

  scope :unseen, -> { where(seen: false) }
  scope :seen, -> { where(seen: true) }

  def mark_seen
    update!(seen: true)
  end
end
