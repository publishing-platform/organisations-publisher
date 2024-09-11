Rails.application.routes.draw do
  root to: redirect("/organisations")

  resources :organisations

  get "up" => "rails/health#show", as: :rails_health_check
end
