require "jwt"
require "random/secure"

class SessionController < Calm::Controller::ApplicationController
  def sign_in(render)
    # @context.flash << HTTP::Server::Flash.new("success", "Signed in successfully!")

    # args = {
    #  "submit_url" => "x",
    # }

    render.with # args
  end

  def sign_out(render)
    render.sign_out
    render.flash("info", t("session_controller.signed_out"))

    render.redirect_to Calm::Routes.home_controller__show
  end

  def authenticate(render)
    post_params = render.post_params
    username = post_params["username"]
    password = post_params["password"]

    user = User.all.where("username", username).where("password", password).first
    if user
      # Create token that expires in 120 minutes
      exp = Time.utc.to_unix + 60*120
      iat = Time.utc.to_unix
      jti = Random::Secure.urlsafe_base64
      # sub = user.username.to_s
      sub = user["username"].as(String)
      uid = user.id
      # TODO: every necessary check
      payload = {"exp" => exp, "iat" => iat, "jti" => jti, "sub" => sub, "uid" => uid}
      token = JWT.encode(payload, Calm.settings.secret, JWT::Algorithm::HS256)
      # Create token that expires in 10 minutes
      refresh_exp = Time.utc.to_unix + 60*10
      refresh_payload = {"exp" => refresh_exp, "uid" => uid}
      refresh_token = JWT.encode(refresh_payload, Calm.settings.refresh_secret, JWT::Algorithm::HS256)
      Log.info { "Token created" }
      render.flash("success", t("session_controller.signed_in_successfully"))
      render.response.headers.add("Set-Cookie", "token=#{token}; path=/;")
      render.response.headers.add("Set-Cookie", "refresh_token=#{refresh_token}; path=/; HttpOnly;")
      # render.response.headers["HX-Redirect"] = "/"

      render.username = sub
      # render text: "Hello #{token}"
      render.redirect_to Calm::Routes.home_controller__show
    else
      # render text: "Error"
      render.flash("danger", t("session_controller.invalid_username_or_password"))
      render.redirect_to Calm::Routes.session_controller__sign_in
    end

    return ""
  end
end
