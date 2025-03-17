class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :setting_id
      t.string :value

      t.timestamps
    end
  end
end
