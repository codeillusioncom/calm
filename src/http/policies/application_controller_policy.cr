module Calm
  module Handler
    class ApplicationControllerPolicy
      property username : String?
      property object : Calm::Db::Base?

      def initialize
      end

      def initialize(@username, @object)
      end

      macro method_missing(call)
        def {{call.name}}
          false
        end
      end
    end
  end
end
