class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.date :closed_at
      t.boolean :closed, default: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
