class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notify_new_act, :boolean, default: true
    add_column :users, :notify_change_state, :boolean, default: true
    add_column :users, :notify_delete_instrument, :boolean, default: true
    add_column :users, :notify_change_instrument, :boolean, default: true
  end
end
