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

  def update
    user_params = params.require(:user).permit(:username, :photo)

    if user_params[:username].present? && user_params[:username] != current_user.username
      if User.exists?(username: user_params[:username])
        return redirect_to '/user', alert: t('username_is_taken')
      end
    end

    if user_params[:photo].present? and user_params[:photo] != current_user.photo and user_params[:photo] != ''
      attachment = Attachment.find_by_photo(photo: user_params[:photo])

      if attachment && attachment.type != 'photo'
        return redirect_to '/user', alert: t('attachment_incorrect_type')
      end
    end

    if current_user.update(user_params)
      redirect_to '/user', notice: t('saved')
    else
      render :edit, alert: t('failed_to_save_changes')
    end
  end

  def remove_photo
    if current_user.photo.present?
      attachment = Attachment.find_by_photo(photo: current_user.photo.to_s)

      if attachment
        attachment.destroy
        current_user.update(photo: nil)
        render json: { notice: t('saved') }, status: :ok
      else
        render json: { alert: t('failed_to_save_changes') }, status: :unprocessable_entity
      end
    else
      render json: { alert: t('failed_to_save_changes') }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password)
  end
end
