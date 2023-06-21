require "jwt"
require "random/secure"

class SessionController < Calm::Controller::ApplicationController
  def sign_in(render)
    # @context.flash << HTTP::Server::Flash.new("success", "Signed in successfully!")

    args = {
      "x" => 2,
      "y" => "alma",
    }

    render.with args
  end

  # def destroy
  #   @context.username = nil
  #   @response.headers.add("Set-Cookie", "token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT")
  #   @response.redirect("/")
  # end

  def authenticate
    puts "auth"
    respond_to do |format|
      format.html do
        username = @object["username"]
        password = @object["password"]

        user = User.all.where("username", username).where("password", password).first
        if user
          # Create token that expires in 20 minutes
          exp = Time.utc.to_unix + 60*20
          iat = Time.utc.to_unix
          jti = Random::Secure.urlsafe_base64
          # sub = user.username.to_s
          sub = user["username"].as(String)
          uid = user.id
          payload = {"exp" => exp, "iat" => iat, "jti" => jti, "sub" => sub, "uid" => uid}
          token = JWT.encode(payload, Calm.settings.secret, JWT::Algorithm::HS256)
          Log.info { "Token created" }
          @context.flash << HTTP::Server::Flash.new("success", "Signed in successfully!")
          @response.headers.add("Set-Cookie", "token=#{token}; path=/;")
          @response.headers["HX-Redirect"] = "/"

          @context.username = sub
          render text: "Hello #{token}"
        else
          render text: "Error"
        end
      end
    end
  end
end
