class User < Calm::Db::Base
  mapping({id: Int32, username: String, password: String, email: String, invalid_sign_in_count: Int64})

  validates_presence_of([:username, :password, :email])
  # default_values({invalid_sign_in_count: 0})

  # TODO: default values
end
