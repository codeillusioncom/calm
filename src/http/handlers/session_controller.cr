require "jwt"
require "random/secure"

class SessionController < Calm::Controller::ApplicationController
  def sign_in(render)
    # @context.flash << HTTP::Server::Flash.new("success", "Signed in successfully!")

    args = {
      "submit_url" => "x",
    }

    render.with args
  end

  def sign_out(render)
    render.sign_out

    render.response.redirect("/")
    render.with
  end

  def authenticate(render)
    post_params = render.post_params
    username = post_params["username"]
    password = post_params["password"]

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
      # @context.flash << HTTP::Server::Flash.new("success", "Signed in successfully!")
      render.response.headers.add("Set-Cookie", "token=#{token}; path=/;")
      render.response.headers["HX-Redirect"] = "/"

      render.username = sub
      # render text: "Hello #{token}"
    else
      # render text: "Error"
      render.flash("error", "Invalid username or password!")
    end
    "bla"
  end
end
