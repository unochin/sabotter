class AddPasswordToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email, :string
    add_column :users, :crypted_password, :string
  end
end
