class Notification < ApplicationRecord
  belongs_to :user, counter_cache: true

  validates :trigger_type, presence: true
  validates :trigger_id, presence: true
  validates :triggered_by_id, presence: true
  validates :message, presence: true

  scope :unseen, -> { where('seen = false') }
  scope :seen, -> { where('seen = true') }

  def mark_seen
    return if seen

    self.seen = true
    save
  end
end
