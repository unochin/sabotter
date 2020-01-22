class SorceryCore < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name,            null: false
      t.string :icon_img_url
      t.string :access_token
      t.string :access_token_secret

      t.timestamps                null: false
    end

    add_index :users, :access_token, unique: true
  end
end
