module SessionsHelper
  def create_session(user: User)
    session_token = SecureRandom.hex(64)

    Rails.cache.write("session_#{session_token}", user.id, expires_in: 1.week)
    Rails.cache.write(user.id, session_token, expires_in: 1.week)

    session_token
  end
end
