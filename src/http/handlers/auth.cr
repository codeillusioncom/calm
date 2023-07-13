module Calm
  module Http
    module TokenGenerator
    end

    module Handler
      class Auth
        include ::HTTP::Handler
        include TokenGenerator

        def reauth_with_refresh_token
          # refresh_token = JWT.decode(cookies["refresh_token"].value, Calm.settings.refresh_secret, JWT::Algorithm::HS256)

          return true
        end

        def call(context : ::HTTP::Server::Context)
          request = context.request
          response = context.response
          cookies = HTTP::Cookies.from_client_headers(request.headers)

          if cookies.has_key?("token") && cookies["token"] && cookies["token"] != ""
            begin
              payload, header = JWT.decode(cookies["token"].value, Calm.settings.secret, JWT::Algorithm::HS256)
              context.username = payload["sub"].as_s
            rescue JWT::ExpiredSignatureError
              Log.info { "Token expired #{cookies["token"]}." }
              context.sign_out unless reauth_with_refresh_token
            end
          else
            #
          end

          call_next(context)
          # rescue e : Exception
          #  Log.error { "Internal Server Error: #{context.request.path}\n#{e.inspect_with_backtrace}" }
        end
      end
    end
  end
end
