class CreateActs < ActiveRecord::Migration[7.0]
  def change
    create_table :acts do |t|
      t.integer :intstrument_state, null: false
      t.json :images
      t.integer :instrument_id, null: false
      t.integer :user_id, null: false
      t.integer :previous_act_id
      t.integer :company_id
      t.string :comment

      t.timestamps
    end
  end
end
