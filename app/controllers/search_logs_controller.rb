class SearchLogsController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    # POST /search_logs
    def create
        session_id = params[:session_id]
        ip         = request.remote_ip
        query      = params[:query].strip.downcase
      
        last_log = SearchLog.where(session_id: session_id, ip_address: ip).order(created_at: :desc).first
      
        if should_replace_last_log?(last_log, query)
          last_log.update(query: query)
        else
          SearchLog.create!(session_id: session_id, ip_address: ip, query: query)
        end
      end
  
    # GET /search_logs
    def index
        ip = request.remote_ip
      
        # Get analytics (top 10 queries)
        analytics = SearchLog
                    .where(ip_address: ip)
                    .group(:query)
                    .order(Arel.sql('COUNT(id) DESC'))
                    .limit(10)
                    .count(:id)
                    .map { |query, count| { query: query, count: count } }

      
        # Get last 10 queries
        recent = SearchLog
                   .where(ip_address: ip)
                   .order(created_at: :desc)
                   .limit(10)
                   .pluck(:query, :created_at)
                   .map { |query, time| { query: query, created_at: time } }
      
        render json: { analytics: analytics, recent: recent }
      end
      
  
    private

    def should_replace_last_log?(last_log, new_query)
      return false if last_log.nil?
      return false if new_query.blank?
    
      extended = new_query.start_with?(last_log.query)
    end
  end
  