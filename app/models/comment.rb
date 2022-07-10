class Comment < ApplicationRecord
  include Notifiable

  belongs_to :post, counter_cache: true
  belongs_to :user, counter_cache: true

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :content, presence: true
end
