class AddPswToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :psw, :string
  end
end
