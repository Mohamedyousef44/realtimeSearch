class AddIndexesToSearchLogs < ActiveRecord::Migration[8.0]
  def change
    add_index :search_logs, :ip_address
    add_index :search_logs, :session_id
  end
end
