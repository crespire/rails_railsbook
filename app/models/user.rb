class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: %i[github google_oauth2]

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
           class_name: :Request,
           dependent: :destroy

  has_many :friends_sent, -> { merge(Request.accepted) }, through: :sent_requests, source: :friend
  has_many :friends_rec, -> { merge(Request.accepted) }, through: :received_requests, source: :user
  has_many :pending_friends_sent, -> { merge(Request.pending) }, through: :sent_requests, source: :friend
  has_many :pending_friends_rec, -> { merge(Request.pending) }, through: :received_requests, source: :user

  has_many :likes, foreign_key: :liked_by, dependent: :destroy
  has_many :notifications, foreign_key: :target_id, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  def friends
    friends_sent + friends_rec
  end

  def pending_friends
    pending_friends_sent + pending_friends_rec
  end

  def all_friends
    friends + pending_friends
  end

  def all_requests
    sent_requests + received_requests
  end

  def find_request(other)
    return nil if other == self

    Request.find_by(friend: other, user: self) || Request.find_by(user: other, friend: self)
  end

  def already_liked?(resource)
    Like.where(liked_by: id, likeable_type: resource.class.to_s, likeable_id: resource.id).exists?
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0, 20]
      )
    end
    user
end
end
