class AddLikesCounterToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :likes_count, :integer
  end
end
