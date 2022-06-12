class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :email, format: Devise.email_regexp
          
  has_many :requests
  has_many :friends, through: :requests

  has_many :likes, foreign_key: :liked_by, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
end
