Rails.application.routes.draw do
  resources :search_logs, only: [:create, :index]
end
