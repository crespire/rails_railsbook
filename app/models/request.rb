class Request < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :friend, class_name: :User

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :user_id, uniqueness: { scope: [:friend_id] }

  scope :accepted, -> { where('accepted = true') }
  scope :pending, -> { where('accepted = false') }

  def accept_request
    update!(accepted: true)
  end
end
