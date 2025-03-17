class AddLanguageToSettingOptions < ActiveRecord::Migration[8.0]
  def up
    SettingOption.create(name: 'language', default_value: 'ru')
  end

  def down
    SettingOption.find_by(name: 'language')&.destroy
  end
end
