require "http/server"
require "socket"

module Calm
  module Http
    class Server
      def self.start
        warn_if_pending_migrations

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

      private def self.warn_if_pending_migrations
        return unless Calm::Cli::Commands::Migrate.pending_migrations?

        Log.error { "Migrations are pending, please run `calm db migrate`." }
        exit -3
      end
    end
  end
end
