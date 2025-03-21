class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

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
    @filters = params.permit(:id, :title, :description, :user_id)

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

  def update
    if @topic.update(topic_params)
      redirect_to topic_path(@topic), notice: t('saved')
    else
      render :edit
    end
  end

  def destroy
    @topic.destroy
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