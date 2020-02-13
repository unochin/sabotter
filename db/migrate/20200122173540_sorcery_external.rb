class SorceryExternal < ActiveRecord::Migration[5.2]
  def change
    create_table :authentications do |t|
      t.references :user, null: false
      t.string :provider, :uid, null: false

      t.timestamps              null: false
    end

    add_index :authentications, [:provider, :uid]
  end
end
