class RenameUserInLikes < ActiveRecord::Migration[7.0]
  def change
    rename_column :likes, :user_id, :liked_by
  end
end
