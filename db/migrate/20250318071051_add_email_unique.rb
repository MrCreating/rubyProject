class AddEmailUnique < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
