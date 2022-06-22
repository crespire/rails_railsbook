class AddLikesCounterToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :likes_count, :integer
  end
end
