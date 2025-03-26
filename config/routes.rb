Rails.application.routes.draw do
  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  
  root to: redirect("/organisations")

  resources :organisations, except: %i[show destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end
