Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  mount ActionCable.server => "/cable"

  namespace :api do
    namespace :v1 do
      get "health_check", to: "health_check#index"
    end
  end
end
