class TopicsController < ApplicationController
  before_action :require_login
  before_action :set_topic, only: [:show, :edit, :update, :destroy, :add_photo, :delete_photo]
  before_action :moderator_access_level

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new
    if @topic.update(topic_params)
      redirect_to topic_path(@topic), notice: t('created')
    else
      render :new
    end
  end

  def index
    @filters = params.permit(:id, :title, :description, :user_id, :page)

    @page = (@filters[:page] || 1).to_i
    @per_page = 5

    @topic = Topic.all
    @topic = @topic.where("title LIKE ?", "%#{@filters[:title]}%") if @filters[:title].present?
    @topic = @topic.where("description LIKE ?", "%#{@filters[:description]}%") if @filters[:description].present?
    @topic = @topic.where(id: @filters[:id]) if @filters[:id].present?
    @topic = @topic.where(user_id: @filters[:user_id]) if @filters[:user_id].present?

    @total = @topic.count
    @topic = @topic.offset((@page - 1) * @per_page).limit(@per_page)
    @topic = @topic.order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def add_photo
    photo_links = params[:photo_links]

    if photo_links.present?
      photo_links.each do |photo_link|
        @attachment = Attachment.find_by_photo(photo: photo_link)
        if @attachment
          TopicsAttachment.create(topic: @topic, attachment: @attachment)
        else
          render json: { error: 1 }, status: :unprocessable_entity
        end
      end

      render json: { success: 1 }, status: :ok
    end
  end

  def delete_photo
    @attachment = Attachment.find(params[:attachment_id])

    @topic.attachments.delete(@attachment)

    redirect_to topic_path(@topic), notice: t('saved')
  end

  def update
    if @topic.update(topic_params)
      redirect_to topic_path(@topic), notice: t('saved')
    else
      render :edit
    end
  end

  def destroy
    unless @topic == nil
      @topic.destroy
    end

    redirect_to topics_path, notice: t('deleted')
  end

  private
  def topic_params
    params.require(:topic).permit(:title, :description, :user_id)
  end

  def set_topic
    @topic = Topic.find(params[:id])
  end
end