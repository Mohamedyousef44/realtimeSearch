class SearchLogsController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    # POST /search_logs
    def create
      

      session_id = params[:session_id].to_s.strip
      query = params[:query].to_s.strip.downcase
      ip = extract_real_ip(request)

      Rails.logger.info "Create query for IP is #{ip}"
  
      return head :bad_request if session_id.blank? || query.blank?
  
      last_log = SearchLog.where(session_id: session_id, ip_address: ip)
                          .order(created_at: :desc).first
  
      if should_replace_last_log?(last_log, query)
        last_log.update(query: query)
      else
        SearchLog.create!(session_id: session_id, ip_address: ip, query: query)
      end
  
      head :ok
    end
  
    # GET /search_logs
    def index
      ip = extract_real_ip(request)
  
      Rails.logger.info "ip is:  #{ip}"
      analytics = SearchLog
                    .where(ip_address: ip)
                    .group(:query)
                    .order(Arel.sql('COUNT(id) DESC'))
                    .limit(10)
                    .count(:id)
                    .map { |query, count| { query: query, count: count } }
  
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
      return false if last_log.nil? || new_query.blank?
  
      new_query.start_with?(last_log.query)
    end

    private

    def extract_real_ip(request)
      if request.headers['X-Forwarded-For']
        request.headers['X-Forwarded-For'].split(',').first.strip
      else
        request.remote_ip
      end
    end
  end
  