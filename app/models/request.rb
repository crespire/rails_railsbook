class Request < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: :User, dependent: :destroy

  validates :user_id, presence: true
  validates :friend_id, presence: true

  scope :accepted, -> { where('accepted = true') }
  scope :pending, -> { where('accepted = false') }
end
