class Request < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :friend, class_name: :User

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :user_id, uniqueness: { scope: [:friend_id] }
  validate :friend_self

  scope :accepted, -> { where('accepted = true') }
  scope :pending, -> { where('accepted = false') }

  def accept_request
    update!(accepted: true)
  end

  private

  def friend_self
    errors.add(:friend, "can't be yourself.") unless user != friend
  end
end
