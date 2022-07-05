class ChangeFieldNameForTriggerInNotification < ActiveRecord::Migration[7.0]
  def change
    rename_column :notifications, :trigger, :trigger_type
  end
end
