class Like < ApplicationRecord
  include Notifiable

  belongs_to :likeable, polymorphic: true, counter_cache: true
  belongs_to :user, foreign_key: :liked_by, counter_cache: true

  validates :liked_by, presence: true
  validates :likeable_type, presence: true
  validates :likeable_id, presence: true
  validates :liked_by, uniqueness: { scope: %i[likeable_id likeable_type] }
end
