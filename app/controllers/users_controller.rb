class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @filters = params.permit(:id, :username, :email, :access_level, :user_rating, :page)

    @page = (@filters[:page] || 1).to_i
    @per_page = 5

    @users = User.all
    @users = @users.where("username LIKE ?", "%#{@filters[:username]}%") if @filters[:username].present?
    @users = @users.where("email LIKE ?", "%#{@filters[:email]}%") if @filters[:email].present?
    @users = @users.where(access_level: @filters[:access_level]) if @filters[:access_level].present?
    @users = @users.where(user_rating: @filters[:user_rating]) if @filters[:user_rating].present?

    @total = @users.count
    @users = @users.offset((@page - 1) * @per_page).limit(@per_page)
    @users = @users.order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    @params = params.require(:user).permit(:id, :username, :email, :access_level, :user_rating, :page)

    if @user.id == current_user.id && @params[:access_level].to_i != @user.access_level
      redirect_to edit_user_path(@user), alert: t('errors.cannot_change_own_access_level') and return
    end

    if @user.update(@params)
      redirect_to users_path, notice: t('saved')
    else
      render :edit
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
