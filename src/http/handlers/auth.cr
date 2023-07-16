module Calm
  module Http
    module Handler
      class Auth
        include ::HTTP::Handler
        include TokenGenerator

        def reauth_with_refresh_token(cookies, context)
          begin
            payload, header = JWT.decode(cookies["refresh_token"].value, Calm.settings.refresh_token_secret, JWT::Algorithm::HS256)
            user_id = payload["uid"]
            user = User.all.where("id", user_id).first
            if user
              new_access_token = create_token user
              new_refresh_token = create_refresh_token user
              send_token_to_client context.response, new_access_token
              send_refresh_token_to_client context.response, new_refresh_token

              return true
            else
              return false
            end
          rescue Exception
            return false
          end
        end

        def call(context : ::HTTP::Server::Context)
          request = context.request
          response = context.response
          cookies = HTTP::Cookies.from_client_headers(request.headers)

          if cookies.has_key?("token") && cookies["token"] && cookies["token"] != ""
            begin
              payload, header = JWT.decode(cookies["token"].value, Calm.settings.auth_token_secret, JWT::Algorithm::HS256)
              context.username = payload["sub"].as_s
            rescue JWT::ExpiredSignatureError
              Log.info { "Token expired #{cookies["token"]}." }
              context.flash("danger", t("session_controller.token_expired"))

              context.sign_out unless reauth_with_refresh_token cookies, context
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
