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
           foreign_key: :requestor_id,
           class_name: :Request,
           dependent: :destroy

  has_many :received_requests,
           foreign_key: :receiver_id,
           class_name: :Request

  has_many :likes, foreign_key: :liked_by, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def friends
    sent = User.joins(:received_requests).where('accepted = true').where('requestor_id = ?', id)
    received = User.joins(:sent_requests).where('accepted = true').where('receiver_id = ?', id)
    sent + received
  end

  def pending_friends
    sent = User.joins(:received_requests).where('accepted = false').where('requestor_id = ?', id)
    received = User.joins(:sent_requests).where('accepted = false').where('receiver_id = ?', id)
    sent + received
  end

  def all_requests
    sent = Request.where('requestor_id = ?', id)
    received = Request.where('receiver_id = ?', id)
    sent + received
  end

  def pending_requests
    sent = Request.where('requestor_id = ?', id).where('accepted = ?', false)
    received = Request.where('receiver_id = ?', id).where('accepted = ?', false)
    sent + received
  end

  def accepted_requests
    sent = Request.where('requestor_id = ?', id).where('accepted = ?', true)
    received = Request.where('receiver_id = ?', id).where('accepted = ?', true)
    sent + received
  end
end
