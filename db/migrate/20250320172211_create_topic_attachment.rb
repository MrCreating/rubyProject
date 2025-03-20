class CreateTopicAttachment < ActiveRecord::Migration[8.0]
  def change
    create_table :topic_attachment do |t|
      t.references :topic, foreign_key: { to_table: :topic }, null: false
      t.references :attachment, foreign_key: true, null: false
    end
  end
end
