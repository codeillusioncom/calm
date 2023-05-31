module Calm
  module Db
    class General
      class_getter table_name

      @wheres = [] of String

      def self.create_table(table_name, table_columns)
      end

      def self.table_exists(table_name)
      end

      def self.insert_into(table_name, props)
      end

      def self.all
      end

      def self.where
      end
    end
  end
end
