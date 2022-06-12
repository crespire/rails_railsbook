class Friend < ApplicationRecord
  has_many :requests
  has_many :users, -> { merge(Request.accepted) }, source: :friend, through: :requests, inverse_of: :friends
end
