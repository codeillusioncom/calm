require "socket"

module Calm
  module Cli
    module Commands
      class Test < Base
        @@command_name = "test"

        def setup
          @parser.on("test", "Start tests") do
            process = Process.new("crystal", ["spec"], output: Process::Redirect::Pipe)
            pp process.output.gets_to_end
            process.wait.success?

            exit
          end
        end
      end
    end
  end
end
