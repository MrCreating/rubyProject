class Setting < ApplicationRecord
  belongs_to :user

  def self.get_value(user: User, setting_id: Integer)
    user_id = user.id

    setting = find_by(user_id: user_id, setting_id: setting_id)

    if setting
      setting.value
    else
      default_setting = SettingOption.find_by(id: setting_id)
      default_setting&.default_value
    end
  end

  def self.set_value(user: User, setting_id: Integer, value: String)
    user_id = user.id
    setting = find_or_initialize_by(user_id: user_id, setting_id: setting_id)
    setting.value = value
    setting.save!
  end
end
