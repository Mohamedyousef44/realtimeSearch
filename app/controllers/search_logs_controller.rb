class SearchLogsController < ApplicationController
  
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
  
  end