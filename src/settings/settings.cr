module Calm
  class Settings
    property database_url
    property debug
    property host
    property items_on_page : Int32
    property log_level
    property port
    property project_name
    property refresh_secret
    property secret
    property time_zone
    property x_frame_options

    def initialize
      @project_name = Dir.current.split("/").last

      @database_url = "postgres://admin:adminadmin@localhost:5432/#{@project_name}_#{Calm.env}"
      @debug = false
      @host = "127.0.0.1"
      @items_on_page = 25
      @log_level = ::Log::Severity::Info
      @port = 3001
      @refresh_secret = "ChangeMe2"
      @secret = "ChangeMe"
      @time_zone = Time::Location.load("UTC")
      @x_frame_options = "DENY"
    end
  end
end
