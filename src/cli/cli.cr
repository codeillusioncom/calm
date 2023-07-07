require "option_parser"

module Calm
  module Cli
    class Cli
      @@commands = [] of Commands::Base.class

      def initialize(
        @options : Array(String),
        @stdout : IO = STDOUT,
        @stderr : IO = STDERR
      )
        @project_dir = Dir.current
        @parser = OptionParser.new

        initialize_locale
      end

      def self.register_command(command_klass : Commands::Base.class)
        @@commands << command_klass
      end

      def initialize_locale
        puts "Initializing locale..."
        I18n.config.loaders << I18n::Loader::YAML.new("src/config/locales")
        I18n.config.default_locale = :en
        I18n.init

        puts I18n.t("machines.index.title")
      end

      def run
        @@commands.each do |command|
          command.new(@parser, @project_dir).setup
        end

        @parser.banner = "Usage: calm [command]"

        @parser.on("-h", "--help", "Show this help") do
          puts @parser
          exit
        end

        @parser.on("-d", "--debug", "Show debug information") do
          ::Log.setup(:debug)
        end

        unless @parser.parse
          unless (ENV.has_key?("CALM_ENV") && ENV["CALM_ENV"] == "test")
            puts @parser
            exit(1)
          end
        end
      end
    end
  end
end
