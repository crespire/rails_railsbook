class UpdatePostAndCommentToUseActionText < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :content
    remove_column :comments, :content
  end
end
