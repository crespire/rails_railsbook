class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, as: :likeable, counter_cache: true
  has_many :comments, dependent: :destroy, counter_cache: true

  validates :content, presence: true
end
