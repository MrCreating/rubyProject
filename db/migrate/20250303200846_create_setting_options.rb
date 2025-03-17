class CreateSettingOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :setting_options do |t|
      t.string :name
      t.string :default_value

      t.timestamps
    end
  end
end
