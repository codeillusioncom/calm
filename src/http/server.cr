require "http/server"
require "socket"

module Calm
  module Http
    class Server
      def self.start
        address = Socket::IPAddress.new "127.0.0.1", 3001

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
      ])
    end
  end
end
