# frozen_string_literal: true

module Mutations
  class GithubAuth < BaseMutation
    field :auth_payload, Types::AuthPayloadType, null: false

    argument :code, String, required: true

    GITHUB_TOKEN_URL = "https://github.com/login/oauth/access_token"
    GITHUB_USER_URL = "https://api.github.com/user"

    def resolve(code:)
      token = request_github_token(code)
      user_info = request_github_user_info(token)

      user = create_or_update_user(user_info)

      {
        auth_payload: {
          token: token,
          user: user,
        },
      }
    end

    private

      def request_github_token(code)
        response = make_http_request(
          url: GITHUB_TOKEN_URL,
          method: :post,
          body: {
            client_id: ENV["GITHUB_CLIENT_ID"],
            client_secret: ENV["GITHUB_CLIENT_SECRET"],
            code: code,
          },
        )

        response["access_token"]
      end

      def request_github_user_info(token)
        response = make_http_request(
          url: GITHUB_USER_URL,
          method: :get,
          headers: { "Authorization" => "Bearer #{token}" },
        )

        {
          name: response["name"],
          github_login: response["login"],
          github_token: token,
          avatar: response["avatar_url"],
        }
      end

      def make_http_request(url:, method:, body: nil, headers: {})
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = request_class_for(method).new(uri.to_s)
        request.content_type = "application/json"
        request["Accept"] = "application/json"
        headers.each {|key, value| request[key] = value }
        request.body = body.to_json if body

        response = http.request(request)

        handle_response(response)
      end

      def request_class_for(method)
        case method
        when :get then Net::HTTP::Get
        when :post then Net::HTTP::Post
        else
          raise ArgumentError, "Unsupported HTTP method: #{method}"
        end
      end

      def handle_response(response)
        unless response.is_a?(Net::HTTPSuccess)
          Rails.logger.error "GitHub API Error: #{response.body}"
          raise GraphQL::ExecutionError, "GitHub APIエラー"
        end

        JSON.parse(response.body)
      rescue JSON::ParserError => e
        Rails.logger.error "JSON parse error: #{e.message}"
        raise GraphQL::ExecutionError, "レスポンスの解析に失敗しました"
      end

      def create_or_update_user(user_info)
        User.find_or_initialize_by(github_login: user_info[:github_login]).tap do |user|
          user.update!(user_info)
        end
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "User update error: #{e.message}"
        raise GraphQL::ExecutionError, "ユーザー情報の更新に失敗しました"
      end
  end
end
