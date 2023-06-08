module Calm
  module Cli
    module Commands
      class Serve < Base
        @@command_name = "serve"

        def setup
          @parser.on("server", "start server") do
            parser.banner = "Usage: calm serve [arguments]"
            @parser.on("-b IP", "--bind=IP", "Specify IP to bind to") { |ip| Calm.settings.host = ip }
            @parser.on("-p PORT", "--port=PORT", "Specify port to bind to") { |port| Calm.settings.port = port.to_i }
            @parser.on("-r", "--reload", "Enable hot reload") do
              # sentry = Sentry::ProcessRunner.new(
              #   display_name: "calm",
              #   run_command: "./calm",
              #   run_args: ["../calm/src/calm.cr", "server"],
              #   build_command: "crystal",
              #   build_args: ["build", "../calm/src/calm.cr"],
              #   files: ["./src/**/*.cr", "./src/**/*.ecr"],
              #   should_build: true,
              # )
              sentry = Sentry::ProcessRunner.new(
                display_name: "homeweb",
                run_command: "crystal",
                run_args: ["src/homeweb.cr", "server"],
                build_command: "crystal",
                build_args: ["build", "../calm/src/calm.cr"],
                files: ["./src/**/*.cr", "./src/**/*.ecr"],
                should_build: false,
              )
              sentry.run
            end
            @parser.parse

            run
          end
        end

        def run
          Http::Server.start
        end
      end
    end
  end
end
