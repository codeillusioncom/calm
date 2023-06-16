require "form_builder"

class SessionView < Calm::Http::BaseView
  def show
    Calm::UI.new do
      h1 "Sign in"
      user = User.new

      simple_form(user) do |f|
        f.input :username, autofocus: true
        f.input :password, type: "password"

        f.submit
      end
    end
  end
end
