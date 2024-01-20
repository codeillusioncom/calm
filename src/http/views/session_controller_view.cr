require "form_builder"

class SessionControllerView < Calm::Http::BaseView
  def sign_in(context, args)
    context.ui do
      h1 { "Sign in" }
      #   user = User.new

      #   simple_form(user, action: Calm::Routes.session_controller__authenticate) do |f|
      #     f.input :username, autofocus: true
      #     f.input :password, type: "password"

      #     f.submit
      #   end
    end
  end

  def sign_out(context, args)
    ""
  end

  def authenticate(context, args)
  end
end
