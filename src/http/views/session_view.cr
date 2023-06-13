require "form_builder"

class SessionView < Calm::Http::BaseView
  def show
    Water.new do
      h1 "Sign in"
      render(FormBuilder.form(theme: :bootstrap_4_vertical, method: :post, form_html: {style: "margin-top: 20px;", "hx-post": Calm.routes.reverse("user_authenticate"), enctype: "multipart/form-data"}) do |f|
        f << f.field(name: "username", type: :text, label: "Username", input_html: {autofocus: true})
        f << f.field(name: "password", type: :password, label: "Password")
        f << div %|class="mt-2"| do
          button %|type="submit" class="btn btn-primary"| do
            "Sign in"
          end
        end
      end)
    end
  end
end
