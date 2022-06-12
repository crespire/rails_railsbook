class UpdateRequestColumnNames < ActiveRecord::Migration[7.0]
  def change
    rename_column :requests, :requestor_id, :user_id
    rename_column :requests, :receiver_id, :friend_id
  end
end
