class SessionView < Calm::Http::BaseView
  def show
    Water.new do
      h1 "Sign in"
      para "bla bla bla"
    end
  end
end
