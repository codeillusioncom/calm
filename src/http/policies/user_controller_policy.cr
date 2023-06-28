class UserControllerPolicy < Calm::Handler::ApplicationControllerPolicy
  def sign_in?
    !@username
  end

  def sign_out?
    @username
  end

  def authenticate?
    !@username
  end
end
