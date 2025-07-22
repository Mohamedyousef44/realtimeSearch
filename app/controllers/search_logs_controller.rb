class SearchLogsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user

  # POST /search_logs
  def create
    if params[:query].present? && params[:query].length > 2
      @user.search_logs.create!(query: params[:query])
    end
    head :ok
  end

  # GET /search_logs
  def index
  end

  private

  def set_user
    @user = User.find_or_create_by(ip: request.remote_ip)
  end
end