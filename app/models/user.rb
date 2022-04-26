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

  has_many :friends, through: :friendships
end
