module TokenGenerator
  def create_token(user)
    # TODO: every necessary check
    sub = user["username"].as(String)
    uid = user.id
    exp = Time.utc.to_unix + (60 * Calm.settings.auth_token_expiration)
    iat = Time.utc.to_unix
    jti = Random::Secure.urlsafe_base64
    payload = {"exp" => exp, "iat" => iat, "jti" => jti, "sub" => sub, "uid" => uid}

    return JWT.encode(payload, Calm.settings.auth_token_secret, JWT::Algorithm::HS256)
  end

  def create_refresh_token(user)
    uid = user.id
    refresh_exp = Time.utc.to_unix + (60 * Calm.settings.refresh_token_expiration)
    refresh_payload = {"exp" => refresh_exp, "uid" => uid}

    return JWT.encode(refresh_payload, Calm.settings.refresh_token_secret, JWT::Algorithm::HS256)
  end

  def send_token_to_client(response, token)
    response.headers.add("Set-Cookie", "token=#{token}; path=/;")
  end

  def send_refresh_token_to_client(response, refresh_token)
    response.headers.add("Set-Cookie", "refresh_token=#{refresh_token}; path=/; HttpOnly;")
  end
end
