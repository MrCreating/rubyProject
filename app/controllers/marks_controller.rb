class MarksController < ApplicationController
  before_action :user_access_level

  def index
    @filters = params.permit(:search, :page, :topic_id)

    if @filters[:topic_id].present?
      redirect_to mark_path(id: @filters[:topic_id])
    end

    @page = (@filters[:page] || 1).to_i
    @per_page = 10

    @topics = Topic.all

    @topics = @topics.where("title LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if @filters[:search].present?
    @total  = @topics.count
    @topics = @topics.offset((@page - 1) * @per_page).limit(@per_page)
    @topics = @topics.order(created_at: :desc)
  end

  def show
    @topic = Topic.find(params[:id])
    @vote = @topic.votes.find_or_initialize_by(user: current_user)
    @votes = @topic.votes.includes(:user)
    @average_score = @votes.average(:score).to_f
  end

  def vote
    @topic = Topic.find(params[:id])
    @vote = @topic.votes.find_or_initialize_by(user: current_user)

    if @vote.update(vote_params)
      redirect_to mark_path(@topic), notice: t('saved')
    else
      redirect_to mark_path(@topic), alert: t('failed_to_save_changes')
    end
  end

  private
  def vote_params
    params.require(:vote).permit(:score)
  end
end
