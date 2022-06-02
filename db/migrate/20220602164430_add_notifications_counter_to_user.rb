class AddNotificationsCounterToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notifications_count, :integer
  end
end
