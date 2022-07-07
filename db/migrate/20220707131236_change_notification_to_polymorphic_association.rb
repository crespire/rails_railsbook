class ChangeNotificationToPolymorphicAssociation < ActiveRecord::Migration[7.0]
  def change
    rename_column :notifications, :trigger_type, :notifiable_type
    rename_column :notifications, :trigger_id, :notifiable_id
    rename_column :notifications, :triggered_by_id, :target_id
  end
end
