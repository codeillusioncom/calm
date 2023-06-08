require "sentry"
require "socket"

require "../utils/run_command"

module Calm
  module Cli
    module Commands
      class Version < Base
        include Calm::Utils

        @@command_name = "version"

        @version : String? = nil

        def setup
          return unless calm_project?

          @parser.on("version", "change to this new version") do |new_version|
            @parser.parse

            run
          end
        end

        def run
          current_version = get_current_version

          if ARGV.size == 2
            new_version = ARGV[1]

            puts "the CURRENT version is #{current_version},"
            print "the NEW version will be #{new_version} (y/n) "
            answer = gets.not_nil!.chomp

            if answer == "y"
              # TODO
              change_shard_yml_version(new_version, current_version)
              change_calm_cr_version(new_version, current_version)
              commit_two_files(new_version, current_version)
              create_tag(new_version, current_version)
            else
              puts "Cancelled by user."
            end
          else
            print_current_version
          end

          exit
        end

        private def get_current_version
          @version || File.each_line("./shard.yml") do |line|
            match = line.match /version: ([0-9]+\.[0-9]+\.[0-9]+)/

            return @version = match[1] if !match.nil? && match.size == 2
          end
        end

        private def new_version_valid?(version)
          get_current_version.match(/[0-9]+\.[0-9]+\.[0-9]+/)
        end

        private def print_current_version
          puts "The current version is #{get_current_version}"
        end

        private def change_shard_yml_version(new_version, old_version)
          puts "writing shard.yml..."

          shard_yml_path = "./shard.yml"
          shard_yml_content = File.read(shard_yml_path)
          new_shard_yml_content = shard_yml_content.sub(/version: #{old_version}/, "version: #{new_version}")
          File.write(shard_yml_path, new_shard_yml_content)
        end

        private def change_calm_cr_version(new_version, old_version)
          puts "writing calm.cr..."

          calm_cr_path = "./src/calm.cr"
          calm_cr_content = File.read(calm_cr_path)
          new_calm_cr_content = calm_cr_content.sub(/  VERSION = \"#{old_version}\"/, "  VERSION = \"#{new_version}\"")
          File.write(calm_cr_path, new_calm_cr_content)
        end

        private def commit_two_files(new_version, old_version)
          puts "committing shard.yml and calm.cr..."

          result = run_command("git", ["rev-parse", "--abbrev-ref", "HEAD"])

          if result[0] == 0
            if result[1].chomp == "dev"
              result = run_command("git", ["commit", "-a", "-m", "\"v#{old_version} -> v#{new_version}\""])
            else
              puts "ERROR: current branch is #{result[1]}"
            end
          else
            puts "ERROR: #{result[1]}"
          end
        end

        private def create_tag(new_version, old_version)
          puts "tagging repository..."

          result = run_command("git", ["tag", "v#{new_version}"])

          if result[0] == 0
            puts "...done!"
          else
            puts "ERROR: #{result[1]}"
          end
        end

        private def calm_project?
          File.exists?("./src/calm.cr")
        end
      end
    end
  end
end
