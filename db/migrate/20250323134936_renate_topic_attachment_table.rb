class RenateTopicAttachmentTable < ActiveRecord::Migration[8.0]
  def change
    create_table :topics_attachments do |t|
      t.references :topic, foreign_key: true, null: false
      t.references :attachment, foreign_key: true, null: false
    end
  end
end
