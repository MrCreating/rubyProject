class UserController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:new, :create]

  include SessionsHelper

  def new
    @user = User.new
  end

  def create
    unless params[:password] == params[:confirmation_password]
      render json: { alert: 'Пароли не совпадают', error: 1 }, status: :unprocessable_entity and return
    end

    if User.exists?(email: params[:email])
      render json: { alert: 'Этот email уже занят', error: 1 }, status: :unprocessable_entity and return
    end

    if User.exists?(username: params[:username])
      render json: { alert: 'Это имя пользователя уже занято', error: 1 }, status: :unprocessable_entity and return
    end

    @user = User.new(user_params)

    if @user.save
      session_token = create_session(user: @user)
      session[:session_token] = session_token

      render json: { notice: 'Регистрация успешна', redirect_url: '/' }, status: :ok
    else
      render json: { alert: 'Не удалось зарегистрироваться', error: 1 }, status: :unprocessable_entity
    end
  end

  def index
    @user = current_user
  end

  private

  def user_params
    params.permit(:username, :email, :password)
  end
end
