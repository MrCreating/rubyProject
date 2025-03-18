class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  skip_before_action :verify_authenticity_token
  before_action :set_layout, :set_locale

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    render json: { error: 1, message: 'Entity not found' }, status: :not_found
  end

  def set_locale
    if logged_in?
      user_language = Setting.get_value(user: current_user, setting_id: SettingOption.find_by(name: 'language'))
      Rails.logger.debug user_language
      I18n.locale = user_language.presence || I18n.default_locale
    else
      I18n.locale = session[:locale] || I18n.default_locale
    end
  end

  def switch_locale
    if logged_in?
      Setting.set_value(user: current_user, setting: SettingOption.find_by(name: 'language'), value: params[:locale])
    else
      session[:locale] = params[:locale]
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def current_user
    if session[:session_token].present?
      user_id = Rails.cache.read("session_#{session[:session_token]}")

      @current_user ||= User.find_by(id: user_id) if user_id
    end
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless session[:session_token].present? && Rails.cache.read("session_#{session[:session_token]}").present?
      redirect_to login_path
    end
  end

  def redirect_if_logged_in
    if logged_in?
      redirect_to root_path
    end
  end

  def set_layout
    if logged_in?
      self.class.layout 'main'
    else
      self.class.layout 'application'
    end
  end
end
