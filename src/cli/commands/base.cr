module Calm
  module Cli
    module Commands
      abstract class Base
        @@command_name : String = ""

        getter project_dir
        getter parser
        getter stderr
        getter stdin
        getter stdout

        def self.command_name
          return @@command_name unless @@command_name.empty?
          @@command_name = name.split("::").last.underscore
        end

        def initialize(@parser : OptionParser,
                       @project_dir : String)
        end

        macro inherited
          Calm::Cli::Cli.register_command({{ @type }})
        end

        def run
        end

        def setup
        end
      end
    end
  end
end
