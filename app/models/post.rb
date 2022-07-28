class Post < ApplicationRecord
  include Attachable

  belongs_to :user, counter_cache: true
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy, inverse_of: :post
  has_rich_text :content

  validate :attachment_type_allowed
  validate :attachment_size_allowed
  validates_with RichContentValidator
end
