class AddMessageToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :message, :string
  end
end
