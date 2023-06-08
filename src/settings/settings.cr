module Calm
  class Settings
    property database_url
    property debug
    property host
    property log_level
    property port
    property items_on_page
    property project_name

    def initialize
      @project_name = Dir.current.split("/").last
      @database_url = "postgres://admin:adminadmin@localhost:5432/#{@project_name}_#{Calm.env}"
      @debug = false
      @host = "127.0.0.1"
      @log_level = ::Log::Severity::Info
      @port = 3001
      @items_on_page = 25
    end

    def self.register_settings_namespace(ns : String)
      @@registered_settings_namespaces << ns
    end
  end
end
