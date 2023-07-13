require "./db_converters"

module Calm
  module Db
    module PersistenceKlazz
      include Calm::DbConverters

      def id_key
        "id"
      end

      def table_name
        self.name.downcase
      end

      def create_table_script
        Calm::Db::Psql.create_table_script(self.table_name, @@STRUCT, self.id_key)
      end

      def create_table
        Calm::Db::Psql.create_table(self.table_name, @@STRUCT, self.id_key)
      end

      def from_params(params, variables)
        obj = self.new

        variables.each do |var|
          obj[var] = params[var]
        end

        return obj
      end

      def self.create_table_if_not_exists
        self.create_table unless self.table_exists?
      end

      def table_exists?
        Calm::Db::Psql.table_exists?(self.table_name)
      end

      def size(where = "")
        return Calm::Db::Psql.size(self.table_name, where)
      end

      def all
        return Calm::Db::ResultSet(self).new("select * from \"#{self.table_name}\"")
      end
    end
  end
end
