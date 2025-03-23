class SettingsController < ApplicationController
  before_action :require_login
  before_action :user_access_level

  def index
  end

  def update_language
    new_language = params[:language]

    Setting.set_value(user: current_user, setting: SettingOption.find_by(name: 'language'), value: new_language)
    I18n.locale = new_language.to_sym
    session[:locale] = new_language

    redirect_to settings_path, notice: t('saved')
  end
end
