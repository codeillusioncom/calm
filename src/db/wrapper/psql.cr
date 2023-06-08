require "../db_converters"

require "./general"

module Calm
  module Db
    class Psql < ::Calm::Db::General
      extend Calm::DbConverters

      def self.create_table_script(table_name, types, id)
        "create table \"#{table_name}\" (#{types.each.map { |key, type| "#{key} #{self.convert_type_from_crystal_to_sqlite(key, type, id)}" }.join(", ")});"
      end

      def self.create_table(table_name, types, id)
        command = self.create_table_script(table_name, types, id)

        Log.info { "SQL: #{command}" }

        DB.open Calm.settings.database_url do |db|
          cmd = db.prepared command
          query = cmd.query
          statement = query.statement
        end
      end

      def self.table_exists?(table_name)
        # TODO: public schema
        command = "SELECT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename  = '#{table_name}');"

        DB.open Calm.settings.database_url do |db|
          res = db.query_one command, as: {Bool}
          res == true
        end
      end

      def self.size(table_name, where = "") : Int64
        command = "SELECT count(*) FROM public.#{table_name} #{where};"
        Log.info { "SQL: #{command}" }

        DB.open Calm.settings.database_url do |db|
          res = db.scalar(command)
          if res.nil?
            return 0_i64
          else
            return res.as(Int64)
          end
        end
      end

      def self.insert_into(table_name, values)
        DB.open Calm.settings.database_url do |db|
          question_marks_arr = (1..values.size)
          columns = Array(String).new
          args = Array(Bool | String | Int32 | Int64 | Nil | Array(Symbol)).new
          values.each do |name, value|
            if name == "id"
              question_marks_arr = (1..(values.size - 1))

              next
            end
            columns << name
            args << value
          end
          question_marks = question_marks_arr.map { |n| "$#{n}" }.join(", ")

          sql = "insert into \"#{table_name}\" (#{columns.join(", ")}) values (#{question_marks});"
          Log.info { sql }

          db.exec sql, args: args
        end
      end

      def self.update(table_name, id, id_value, data)
        # data_hash = {} of String => String? | Int64?
        # old_data_hash = {} of String => String? | Int64?
        # diff_hash = {} of String => String? | Int64?

        # data.each { |d| data_hash[d["name"]] = d["value"] }
        # old_data.each { |d| old_data_hash["#{d["name"]}"] = d["value"] }

        # data_hash.each do |d, x|
        #   data_hash.delete(d) if old_data_hash["#{d}_old"] == x
        # end

        DB.open Calm.settings.database_url do |db|
          command = "update \"#{table_name}\" "
          command += "SET " if data.size > 0
          args = [] of Bool | String | Int32 | Int64 | Nil | Array(Symbol)

          i = 0
          sets = data.map do |k, v|
            #  # args << convert_type_from_db_to_crystal(k, v)
            args << v
            i += 1
            "\"#{k}\" = $#{i}"
          end.join(", ")
          command += "#{sets} WHERE \"#{id}\" = '#{id_value}';"
          return true
        end
      end

      def self.delete(table_name, id, id_value)
        DB.open Calm.settings.database_url do |db|
          command = "delete from \"#{table_name}\" "
          command += "where #{id}=?"
          args = [] of Calm::Db::BaseStore::Types
          args << id_value
          db.exec command, args: args
        end
      end

      def self.key_exists?(table_name, key, value)
        DB.open Calm.settings.database_url do |db|
          command = "select exists(select 1 from \"calm\" where '#{key}' = '#{value}');"
          db.scalar(command) == 1
        end
      end

      def self.all
        DB.open Calm.settings.database_url do |db|
          from_rs(db.query("SELECT * FROM #{table_name}"))
        end
      end
    end
  end
end
