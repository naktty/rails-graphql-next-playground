GraphiQL::Rails.config.headers = {
  "Authorization" => ->(_context) {
    "Bearer #{ENV["TMP_TOKEN"]}"
  },
}
