class AddIpToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :ip, :string
    add_index :users, :ip, unique: true
  end
end
