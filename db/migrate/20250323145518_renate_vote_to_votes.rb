class RenateVoteToVotes < ActiveRecord::Migration[8.0]
  def change
    drop_table :vote

    create_table :votes do |t|
      t.references :topic, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :score, default: 0, null: false

      t.timestamps
    end
  end
end
