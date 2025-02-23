if defined?(GraphiQL::Rails) && Rails.env.development?
  GraphiQL::Rails.config.headers = {
    "Authorization" => ->(_context) {
      "Bearer #{ENV["TMP_TOKEN"]}"
    },
  }
end
