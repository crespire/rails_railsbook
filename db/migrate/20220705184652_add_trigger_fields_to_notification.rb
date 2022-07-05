class AddTriggerFieldsToNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :trigger, :string, null: false
    add_column :notifications, :trigger_id, :integer, null: false
  end
end
