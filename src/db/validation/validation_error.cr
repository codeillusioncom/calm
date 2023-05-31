module Calm
  module Db
    module Validation
      class ValidationError < Exception
        property errors = {} of Symbol => String

        def initialize
        end

        def initialize(@errors)
        end
      end
    end
  end
end
