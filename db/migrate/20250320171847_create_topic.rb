class CreateTopic < ActiveRecord::Migration[8.0]
  def change
    create_table :topic do |t|
      t.text :title
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
