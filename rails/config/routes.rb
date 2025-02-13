Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  namespace :api do
    namespace :v1 do
      get "health_check", to: "health_check#index"
    end
  end
end
