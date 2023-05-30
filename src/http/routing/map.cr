module Calm
  module Routing
    class Map
      def initialize
        @rules = [] of Rule::Base
        @reversers = {} of String => Reverser
      end

      def resolve(path : String) : Match
        path_splitted : Array(String) = path.split(".")
        path_without_format = path_splitted[0]

        match = @rules.each do |r|
          matched = r.resolve(path_without_format)
          break matched unless matched.nil?
        end
        raise Errors::NoResolveMatch.new if match.nil?

        match.format = path_splitted[1] if path_splitted.size == 2

        match
      end
    end
  end
end
