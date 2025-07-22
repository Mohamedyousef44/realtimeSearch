class User < ApplicationRecord
    has_many :search_logs
    validates :ip, presence: true, uniqueness: true
end 
