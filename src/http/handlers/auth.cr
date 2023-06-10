module Calm
  module Http
    module Handler
      class Auth
        include ::HTTP::Handler

        def call(context : ::HTTP::Server::Context)
          # @request = @context.request
          request = context.request
          response = context.response
          cookies = HTTP::Cookies.from_client_headers(request.headers)

          if cookies.has_key?("token") && cookies["token"] && cookies["token"] != ""
            begin
              payload, header = JWT.decode(cookies["token"].value, Calm.settings.secret, JWT::Algorithm::HS256)
              context.username = payload["sub"].as_s
            rescue JWT::ExpiredSignatureError
              Log.info { "Token expired #{cookies["token"]}." }
              response.headers.add("Set-Cookie", "token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT")
              context.username = nil
              # response.redirect "/"
            end
          end

          call_next(context)
          # rescue e : Exception
          #  Log.error { "Internal Server Error: #{context.request.path}\n#{e.inspect_with_backtrace}" }
        end
      end
    end
  end
end
