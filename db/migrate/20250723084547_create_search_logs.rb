class CreateSearchLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :search_logs do |t|
      t.string :ip_address
      t.string :query
      t.string :session_id

      t.timestamps
    end
  end
end
