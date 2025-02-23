GraphiQL::Rails.config.headers = {
  'Authorization' => -> (context) {
    "Bearer #{ENV['TMP_TOKEN']}"
  }
}
