class AddExternalPicToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :external_picture, :string, default: nil
  end
end
