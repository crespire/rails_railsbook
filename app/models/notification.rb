class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true, counter_cache: true
  belongs_to :user, foreign_key: :target_id, counter_cache: true

  validates :target_id, presence: true
  validates :notifiable_type, presence: true
  validates :notifiable_id, presence: true
  validates :message, presence: true

  scope :unseen, -> { where('seen = false') }
  scope :seen, -> { where('seen = true') }

  def mark_seen
    return if seen

    self.seen = true
    save
  end
end
