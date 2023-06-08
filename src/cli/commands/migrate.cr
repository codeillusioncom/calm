require "socket"

module Calm
  module Cli
    module Commands
      class Migrate < Base
        @@command_name = "db"
        @@migration_klasses = [] of Calm::Db::Migration

        class_getter migration_klasses

        def self.pending_migrations?
          if CalmConfig.table_exists?
            last_migration_name = CalmConfig.all.where("key", "migrations").first
          else
            return true
          end

          return true if last_migration_name.nil?

          return false if @@migration_klasses.sort.last.class.name == last_migration_name.value

          return true
        end

        def setup
          @parser.on("db", "Database commands") do
            @parser.banner = "Usage: calm db [arguments]"
            @parser.on("migrate", "Run migrations") do
              run_migrations

              exit
            end
            @parser.parse

            puts @parser if ARGV == ["db"]

            exit(1)
          end
        end

        def run_migrations
          # pp CalmConfig.all.where("key", "migrations").first
          if CalmConfig.table_exists?
            last_migration_name = CalmConfig.all.where("key", "migrations").first
          else
            last_migration_name = nil
          end
          do_migration = last_migration_name.nil?

          @@migration_klasses.sort.each do |migration|
            if !last_migration_name.nil? && migration.class.name == last_migration_name.value
              do_migration = true
              next
            end
            next unless do_migration
            if ARGV.size == 3 && ARGV[2] == "down"
              printf "running #{migration.class} down..."
              migration.do(:down)
              puts "OK"
              update_migrations_table migration.class
            else
              printf "running #{migration.class} up..."
              migration.do(:up)
              puts "OK"
              update_migrations_table migration.class
            end
          end
        end

        def self.register_klass(klass : Calm::Db::Migration.class)
          @@migration_klasses << klass.new
        end

        def update_migrations_table(migration_class)
          existing_configs = CalmConfig.all.where("key", "migrations").call
          if existing_configs.size > 0
            existing_config = existing_configs.first
            existing_config.value = migration_class.name
            existing_config.persist!
          else
            config = CalmConfig.new
            config.key = "migrations"
            config.value = migration_class.name
            config.persist!
          end
        rescue e : Calm::Db::Validation::ValidationError
          Log.info { e.errors }
        end
      end
    end
  end
end
