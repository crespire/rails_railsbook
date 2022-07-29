class Post < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy, inverse_of: :post
  has_rich_text :content

  validates_with RichContentValidator
end
