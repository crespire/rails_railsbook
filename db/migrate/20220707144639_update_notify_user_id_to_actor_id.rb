class UpdateNotifyUserIdToActorId < ActiveRecord::Migration[7.0]
  def change
    rename_column :notifications, :user_id, :actor_id
  end
end
