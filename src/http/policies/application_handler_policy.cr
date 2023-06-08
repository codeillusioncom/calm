module Calm
  module Handler
    class ApplicationHandlerPolicy
      property username : String?

      def initialize
      end

      def initialize(@username)
      end

      macro method_missing(call)
        def {{call.name}}
          false
        end
      end
    end
  end
end
