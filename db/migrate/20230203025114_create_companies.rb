class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.integer :tariff_id, null: false
      t.string :name, null: false
      t.string :contact_email, null: false
      t.string :contact_phone, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
