module Calm
  module Routing
    struct Match
      getter handler
      getter kwargs
      getter action
      getter format
      setter format

      def initialize(@handler : Calm::Handler::ApplicationHandler.class, @kwargs = {} of String => Parameter::Types, @action = :show, @format = "
html")
      end
    end
  end
end
