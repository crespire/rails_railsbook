class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :email, format: Devise.email_regexp

  has_many :posts

  has_many :sent_requests,
           foreign_key: :requestor_id,
           class_name: :Request

  has_many :received_requests,
           foreign_key: :receiver_id,
           class_name: :Request

  has_many :friendships_sent, class_name: :Friendship, foreign_key: 'requestor_id'
  has_many :friends_sent, :through => :friendships_sent, :source => 'receiver'

  has_many :friendships_received, class_name: :Friendship, foreign_key: 'receiver_id'
  has_many :friends_received, :through => :friendships_received, :source => 'requestor'
end
