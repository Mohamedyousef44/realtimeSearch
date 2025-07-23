class SearchLog < ApplicationRecord
    validates :query, :session_id, :ip_address, presence: true
  end
  