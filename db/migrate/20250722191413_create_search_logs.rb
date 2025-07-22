class CreateSearchLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :search_logs do |t|
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.string :query

      t.timestamps
    end
  end
end
