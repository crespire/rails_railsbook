class Comment < ApplicationRecord
  include Notifiable
  include Attachable

  belongs_to :post, counter_cache: true
  belongs_to :user, counter_cache: true

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_rich_text :content

  validate :attachment_type_allowed
  validate :attachment_size_allowed
  validates_with RichContentValidator
end
