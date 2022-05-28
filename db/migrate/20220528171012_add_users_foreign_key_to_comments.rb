class AddUsersForeignKeyToComments < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :comments, :users
  end
end
