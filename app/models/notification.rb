class Notification < ApplicationRecord
  belongs_to :user, counter_cache: true

  scope :new, -> { where('seen = false') }
  scope :seen, -> { where('seen = true') }

  def mark_seen
    return if seen

    self.seen = true
    save
  end
end
