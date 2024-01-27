require "jwt"
require "random/secure"

include TokenGenerator

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
    render.flash("success", t("session_controller.signed_out"))

    render.redirect_to Calm::Routes.home_controller__show
  end

  def authenticate(render)
    post_params = render.post_params
    username = post_params["username"]
    password = post_params["password"]

    user = User.all.where("username", username).where("password", password).first
    if user
      token = create_token user
      refresh_token = create_refresh_token user
      Log.info { "Tokens created" }
      render.flash("success", t("session_controller.signed_in_successfully"))
      send_token_to_client render.response, token
      send_refresh_token_to_client render.response, refresh_token

      render.username = user["username"].as(String)
      render.redirect_to Calm::Routes.home_controller__show
    else
      render.flash("danger", t("session_controller.invalid_username_or_password"))
      render.redirect_to Calm::Routes.session_controller__sign_in
    end
  end
end
