require "http/server"
require "socket"

module Calm
  module Http
    class Server
      def self.start
        warn_if_pending_migrations

        address = Socket::IPAddress.new Calm.settings.host, Calm.settings.port

        Log.info { "Starting server..." }

        INSTANCE.bind_tcp address, reuse_port: true

        Signal::HUP.trap do
          puts "Will stop in moment! ({active_requests} active requests)"
          sleep 1.seconds
          INSTANCE.close
        end

        spawn INSTANCE.listen
        puts "listen után..."
      end

      def self.stop
        Log.info { "Stopping server..." }

        while !INSTANCE.closed?
          Log.info { "closing server..." }
          sleep 1.seconds
          INSTANCE.close
        end
      end

      private INSTANCE = HTTP::Server.new([
        ::HTTP::ErrorHandler.new,
        Handler::Logger.new,
        Handler::Error.new,
        Handler::Auth.new,
        Handler::Routing.new,
        HTTP::StaticFileHandler.new("./src/static"),
      ])

      private def self.warn_if_pending_migrations
        return unless Calm::Cli::Commands::Migrate.pending_migrations?

        Log.error { "Migrations are pending, please run `calm db migrate`." }
        exit -3
      end
    end
  end
end
