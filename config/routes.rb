Rails.application.routes.draw do
  resources :search_logs, only: [:create, :index]
  root to: redirect('/index.html')
end
