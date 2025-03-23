class GradesController < ApplicationController
  before_action :moderator_access_level

  def index
    @filters = params.permit(:id, :user_id, :topic_id, :page, :grade)

    @page = (@filters[:page] || 1).to_i
    @per_page = 5

    @votes = Vote.all

    @votes = @votes.where(id: @filters[:id]) if @filters[:id].present?
    @votes = @votes.where(topic_id: @filters[:topic_id]) if @filters[:topic_id].present?
    @votes = @votes.where(user_id: @filters[:user_id]) if @filters[:user_id].present?
    @votes = @votes.where(score: @filters[:grade]) if @filters[:grade].present?

    @total = @votes.count
    @votes = @votes.offset((@page - 1) * @per_page).limit(@per_page)
    @votes = @votes.order(created_at: :desc)
  end
end
