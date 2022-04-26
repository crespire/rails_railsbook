class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.belongs_to :requestor
      t.belongs_to :receiver

      t.timestamps
    end
  end
end
