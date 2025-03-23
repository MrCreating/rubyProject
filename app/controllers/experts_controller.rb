class ExpertsController < ApplicationController
  before_action :require_login
  before_action :admin_access_level

  def index
  end
end
