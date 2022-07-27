class AddOptionalAttributesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :gender, :text, default: 'Prefer not to say'
    add_column :users, :website, :text, default: nil, limit: 100
    add_column :users, :location, :text, default: nil, limit: 100
    add_column :users, :birthday, :date, default: nil
    add_column :users, :show_birth_year, :boolean, default: false
  end
end
