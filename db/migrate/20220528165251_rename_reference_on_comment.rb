class RenameReferenceOnComment < ActiveRecord::Migration[7.0]
  def change
    rename_index :comments, 'index_comments_on_posts_id', 'index_comments_on_post_id'
    rename_column :comments, :posts_id, :post_id
  end
end
