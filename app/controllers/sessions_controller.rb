class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new]

  include SessionsHelper

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session_token = create_session(user: user)

      session[:session_token] = session_token
      render json: { notice: 'Авторизация успешна', redirect_url: '/' }, status: :ok
    else
      render json: { alert: 'Неверное имя пользователя или пароль', error: 1 }, status: :unprocessable_entity
    end
  end

  def destroy
    if session[:session_token].present?
      Rails.cache.delete("session_#{session[:session_token]}")
      session.delete(:session_token)
      redirect_to login_path
    else
      redirect_to login_path, alert: 'Нет активных сессий у сущности'
    end
  end

  def destroy_by_token
    token = params[:token]
    Rails.cache.delete("session_#{token}")

    render json: { success: 1 }
  end

  def list
    unless session[:session_token].present?
      render json: { error: 1 }, status: :unauthorized and return
    end

    @result = []

    Rails.cache.fetch(current_user.id) do |key|
      @result.append({
       key: key,
       user_id: current_user.id,
      })
    end

    render json: @result
  end

  def new
    # code here
  end
end