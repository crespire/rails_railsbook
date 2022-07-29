class Comment < ApplicationRecord
  include Notifiable

  belongs_to :post, counter_cache: true
  belongs_to :user, counter_cache: true

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_rich_text :content

  validates_with RichContentValidator
end
