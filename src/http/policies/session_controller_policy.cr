class SessionControllerPolicy < Calm::Handler::ApplicationControllerPolicy
  def sign_in?
    @username.nil?
  end

  def sign_out?
    !@username.nil?
  end

  def authenticate?
    @username.nil?
  end
end
