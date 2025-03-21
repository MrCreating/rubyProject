class RenameTopicToTopicsAndUpdateKeys < ActiveRecord::Migration[8.0]
  def change
    rename_table :topic, :topics
  end
end
