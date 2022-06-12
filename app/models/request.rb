class Request < ApplicationRecord
  after_save :create_inverse
  after_update :accept_inverse, if: :accepted_change_to_be_saved
  after_destroy :destroy_inverse

  belongs_to :user
  belongs_to :friend, class_name: :User

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :user_id, uniqueness: { scope: [:friend_id] }

  scope :accepted, -> { where('accepted = true') }
  scope :pending, -> { where('accepted = false') }

  private

  def create_inverse
    return if Request.find_by(friend: user, user: friend)

    Request.create(user: friend, friend: user, accepted: accepted)
  end

  def accept_inverse
    puts 'accept inverse'
    return unless accepted

    p self
    inverse = Request.find_by(friend: user, user: friend)
    p inverse
    inverse.accepted = inverse.accepted ? false : true
    inverse.save
  end

  def destroy_inverse
    r = Request.find_by(friend: user, user: friend)
    return unless r

    puts 'Destorying inverse'

    r.destroy
  end
end
