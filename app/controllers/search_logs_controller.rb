class SearchLogsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_user
  
    # POST /search_logs
    def create
      last_log = @user.search_logs.order(created_at: :desc).first
      if params[:query].present? && params[:query].length > 3 &&
         (last_log.nil? || last_log.query != params[:query])
        @user.search_logs.create!(query: params[:query])
      end
      render json: { message: "Log created" }
    end
  
    # GET /search_logs
    def index
      logs = @user.search_logs
      analytics = logs.group(:query).order('count_id DESC').count(:id).map do |query, count|
        { query: query, count: count }
      end
      render json: { analytics: analytics, recent: logs.order(created_at: :desc).limit(10).pluck(:query, :created_at) }
    end
  
    private
  
    def set_user
      @user = User.find_or_create_by(ip: request.remote_ip)
    end
  end
  