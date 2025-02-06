Rails.application.routes.draw do
  root to: redirect("/organisations")

  resources :organisations, except: %i[show destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end
