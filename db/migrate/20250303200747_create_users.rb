class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.integer :access_level
      t.text :photo
      t.integer :user_rating

      t.timestamps
    end
  end
end
