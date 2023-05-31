require "./presence_validator"

module Calm
  module Db
    module Validation
      macro validates_presence_of(array)
      @presence : Array(Symbol) = {{array}}
      end

      def validation_errors
        errors = {} of Symbol => String

        @presence.each do |p|
          Calm::Db::Validation::PresenceValidator.validate(self, p, errors)
        end
        Log.info { errors }
        return errors
      end

      def validate!
        errors = validation_errors

        raise Calm::Db::Validation::ValidationError.new(errors) if invalid?
      end

      def valid?
        return validation_errors.empty?
      end

      def invalid?
        return !valid?
      end
    end
  end
end
