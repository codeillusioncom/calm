require "http/server"
require "socket"

module Calm
  module Http
    class Server
      def self.start
        address = Socket::IPAddress.new Calm.settings.host, Calm.settings.port

        Log.info { "Starting server..." }

        INSTANCE.bind_tcp address
        INSTANCE.listen
      end

      def self.stop
        Log.info { "Stopping server..." }

        INSTANCE.close
      end

      private INSTANCE = HTTP::Server.new([
        ::HTTP::ErrorHandler.new,
        Handler::Routing.new,
      ])
    end
  end
end
