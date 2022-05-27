class UpdateCommentNotBePoly < ActiveRecord::Migration[7.0]
  def change
    remove_index :comments, name: "index_comments_on_commentable"
    remove_column :comments, :commentable_type
    remove_column :comments, :commentable_id
  end
end
