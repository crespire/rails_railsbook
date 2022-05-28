class RemoveTitleFromPost < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :title
  end
end
