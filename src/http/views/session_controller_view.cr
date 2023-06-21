require "form_builder"

class SessionControllerView < Calm::Http::BaseView
  def sign_in(context)
    Calm::UI.new do
      h1 "Sign in"
      user = User.new

      simple_form(user, action: "x") do |f|
        f.input :username, autofocus: true
        f.input :password, type: "password"

        f.submit
      end
    end
  end
end
