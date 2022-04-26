class AddAcceptedStatusToRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :accepted, :boolean, default: false
  end
end
