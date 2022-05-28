class Comment < ApplicationRecord
  belongs_to :post, foreign_key: true
  belongs_to :user, foreign_key: true

  has_many :likes, as: :likeable

  validates :content, presence: true
end
