class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|

      t.timestamps
    end
  end
end
