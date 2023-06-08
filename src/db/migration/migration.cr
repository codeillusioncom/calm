require "comparable"

module Calm
  module Db
    class Migration
      include Comparable(Migration)

      @table_columns = [] of MigrationData

      macro inherited
        Calm::Cli::Commands::Migrate.register_klass({{ @type }})
      end

      def create_table(klass : Calm::Db::Base.class)
        klass.create_table
      end

      def up
      end

      def down
      end

      def do(direction : Symbol)
        command = ""
        if direction == :up
          up
        else
          down
        end

        return command
      end

      def <=>(other : T)
        self.class.name <=> other.class.name
      end
    end
  end
end
