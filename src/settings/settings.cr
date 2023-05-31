module Calm
  class Settings
    property database_url
    property debug
    property host
    property log_level
    property port

    def initialize
      @database_url = "postgres://admin:adminadmin@localhost:5432/calm_#{Calm.env}"
      @debug = false
      @host = "127.0.0.1"
      @log_level = ::Log::Severity::Info
      @port = 3001
    end

    def self.register_settings_namespace(ns : String)
      @@registered_settings_namespaces << ns
    end
  end
end
