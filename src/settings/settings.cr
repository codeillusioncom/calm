module Calm
  class Settings
    property auth_token_expiration
    property auth_token_secret
    property database_url
    property debug
    property default_locale
    property host
    property items_on_page : Int32
    property log_level
    property port
    property project_name
    property refresh_token_expiration
    property refresh_token_secret
    property time_zone
    property x_frame_options

    def initialize
      @project_name = Dir.current.split("/").last

      @auth_token_expiration = 2
      @auth_token_secret = "ChangeMe"
      @database_url = "postgres://admin:adminadmin@localhost:5432/#{@project_name}_#{Calm.env}"
      @debug = false
      @default_locale = "hu"
      @host = "127.0.0.1"
      @items_on_page = 25
      @log_level = ::Log::Severity::Info
      @port = 3001
      @refresh_token_expiration = 5
      @refresh_token_secret = "ChangeMe2"
      @time_zone = Time::Location.load("UTC")
      @x_frame_options = "DENY"
    end
  end
end
