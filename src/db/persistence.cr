require "./db_converters"
require "./validation/validation_error"
require "./wrapper/psql"

module Calm
  module Db
    module Persistence
      include Calm::DbConverters

      # if it's already in the db
      @persisted = false

      def dirty?
        # pp self.class.id_key
        STRUCT.each do |key, value|
          next if key.ends_with?("_old")
          next if self.class.id_key == key

          puts "#{self[key]} - #{self["#{key}_old"]}"
          return true if self[key] != self["#{key}_old"]
        end
        return false
      end

      def persist(throw_exception_on_error = false)
        # before_validation
        res = valid?
        if throw_exception_on_error
          raise Calm::Validation::ValidationError.new unless res
        else
          return false if res == false
        end
        # after_validation
        res |= before_save if self.persisted?
        res |= around_save if self.persisted?
        res |= before_create unless self.persisted?
        res |= around_create unless self.persisted?
        res |= after_create unless self.persisted?
        res |= after_save if self.persisted?

        # after_commit / after_rollback
        @persisted = res
        return res
      end

      def persist!
        persist(true)
      end

      def before_save
        true
      end

      def destroy
        Calm::Db::Psql.delete(self.class.table_name, self.class.id_key, self[self.class.id_key])
      end

      private def create
        data = Hash(String, Bool | String | Int32 | Int64 | Nil).new

        Calm::Db::Psql.insert_into(self.class.table_name, instance_values)
        # TODO:
        return true
      end

      # it is the update
      private def save
        # Calm::Db::Psql.update(self.class.table_name, self.class.id_key, self[self.class.id_key], @props.select { |k, v| k.ends_with?("_old") }, @props.select { |k, v| !k.ends_with?("_old") }, STRUCTure)
        data = Hash(String, Bool | String | Int32 | Int64 | Nil | Array(Symbol)).new
        STRUCT.each do |name, type|
          data[name] = self[name]
        end

        return Calm::Db::Psql.update(self.class.table_name, self.class.id_key, self[self.class.id_key], data)
      end

      def around_save
        return save if dirty?

        return true
      end

      def before_create
        true
      end

      def around_create
        return create
      end

      def after_create
        true
      end

      def after_save
        true
      end
    end
  end
end
