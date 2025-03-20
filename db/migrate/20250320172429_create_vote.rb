class CreateVote < ActiveRecord::Migration[8.0]
  def change
    create_table :vote do |t|
      t.references :topic, null: false, foreign_key: { to_table: :topic }
      t.references :user, null: false, foreign_key: true
      t.integer :score, default: 0, null: false

      t.timestamps
    end
  end
end
