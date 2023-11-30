class CreateInstruments < ActiveRecord::Migration[7.0]
  def change
    create_table :instruments do |t|
      t.integer :state, null: false
      t.string :name, null: false
      t.json :images
      t.integer :price
      t.string :price_currency
      t.integer :company_id

      t.timestamps
    end
  end
end
