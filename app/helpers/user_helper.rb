module UserHelper
  def get_current_user
    if session[:session_token].present?
      user_id = Rails.cache.read("session_#{session[:session_token]}")

      @current_user ||= User.find_by(id: user_id) if user_id
    end
  end
end
