Rails.application.routes.draw do
  get "/", to: "home#index"
  get "/registration", to: "registration#index"
  post "/registration", to: "registration#create"
  get "/registration/show", to: "registration#show"
end
