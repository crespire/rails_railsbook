class AddUniqIndexToRequests < ActiveRecord::Migration[7.0]
  def change
    add_index :requests, [:user_id, :friend_id], unique: true
  end
end
