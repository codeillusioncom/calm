# require "fswatch"

module Calm
  module Cli
    module Commands
      class Serve < Base
        FILE_TIMESTAMPS = {} of String => String # {file => timestamp}

        @@command_name = "serve"

        private def get_timestamp(file : String)
          File.info(file).modification_time.to_unix.to_s
        end

        private def scan_files(files)
          Dir.glob(files) do |file|
            timestamp = get_timestamp(file)
            if FILE_TIMESTAMPS[file]? && FILE_TIMESTAMPS[file] != timestamp
              FILE_TIMESTAMPS[file] = timestamp
              file_changed = true
              puts "🤖  #{file}"
            elsif FILE_TIMESTAMPS[file]?.nil?
              puts "🤖  watching file: #{file}"
              FILE_TIMESTAMPS[file] = timestamp
              # file_changed = true if (app_process && !app_process.terminated?)
            end
          end
        end

        private def files_changed
          old = FILE_TIMESTAMPS.clone

          # scan_files("src/**/*.cr")
          scan_files("./**/*.cr")

          neww = FILE_TIMESTAMPS

          if old == {} of String => String
          else
            if old != neww
              return true
            end
          end

          old = neww
          false
        end

        def setup
          @parser.on("server", "Start server") do
            parser.banner = "Usage: calm serve [arguments]"
            @parser.on("-b IP", "--bind=IP", "Specify IP to bind to") { |ip| Calm.settings.host = ip }
            @parser.on("-p PORT", "--port=PORT", "Specify port to bind to") { |port| Calm.settings.port = port.to_i }
            @parser.on("-r", "--reload", "Enable hot reload") do
              spawn do
                restart = false

                puts "timer started..."

                while !restart
                  restart = files_changed
                  sleep 5
                end

                Calm::Http::Server.stop
                exit
              end
            end
          end
          @parser.parse

          run
        end

        def run
          puts "run"
          Calm::Http::Server.start

          while true
            sleep 10
          end
        end
      end
    end
  end
end
