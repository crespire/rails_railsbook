class Comment < ApplicationRecord
  belongs_to :post, foreign_key: true
  belongs_to :user

  has_many :likes, as: :likeable

  validates :content, presence: true
end
