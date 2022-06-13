class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :email, format: Devise.email_regexp

  has_many :sent_requests,
           foreign_key: :user_id,
           class_name: :Request,
           dependent: :destroy

  has_many :received_requests,
           foreign_key: :friend_id,
           class_name: :Request

  has_many :friends_sent, -> { merge(Request.accepted) }, through: :sent_requests, source: :friend
  has_many :friends_rec, -> { merge(Request.accepted) }, through: :received_requests, source: :user
  has_many :pending_friends_sent, -> { merge(Request.pending) }, through: :sent_requests, source: :friend
  has_many :pending_friends_rec, -> { merge(Request.pending) }, through: :received_requests, source: :user

  has_many :likes, foreign_key: :liked_by, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def friends
    friends_sent + friends_rec
  end

  def pending_friends
    pending_friends_sent + pending_friends_rec
  end
end
