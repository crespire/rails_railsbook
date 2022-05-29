class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, as: :likeable, counter_cache: true, dependent: :destroy
  has_many :comments, dependent: :destroy, counter_cache: true, inverse_of: :post

  validates :content, presence: true
end
