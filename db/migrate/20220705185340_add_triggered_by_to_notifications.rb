class AddTriggeredByToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :triggered_by, foreign_key: { to_table: :users }
  end
end
