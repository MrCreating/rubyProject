class ContentController < ApplicationController
  before_action :require_login
  before_action :admin_access_level

  def index
    @filters = params.permit(:id, :user_id, :access_key, :page)
    @page = (@filters[:page] || 1).to_i
    @per_page = 5

    @attachments = Attachment.all

    @attachments = @attachments.where(id: @filters[:id]) if @filters[:id].present?
    @attachments = @attachments.where(user_id: @filters[:user_id]) if @filters[:user_id].present?
    @attachments = @attachments.where(access_key: @filters[:access_key]) if @filters[:access_key].present?

    @total = @attachments.count
    @attachments = @attachments.offset((@page - 1) * @per_page).limit(@per_page)
    @topic = @attachments.order(created_at: :desc)
  end

  def destroy
    @attachment = Attachment.find_by(id: params[:id])

    unless @attachment == nil
      @attachment.destroy
    end

    redirect_to content_index_path, notice: t('deleted')
  end
end
