class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :access_key
      t.string :type

      t.timestamps
    end
  end
end
