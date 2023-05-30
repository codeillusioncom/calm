require "crinja"

require "./http/context"
require "./http/*"
require "./http/handlers/format/*"
require "./http/handlers/*"
require "./http/policies/*"
require "./http/routing/**"

# TODO: Write documentation for `Calm`
module Calm
  VERSION = "0.1.0"

  @@routes : Routing::Map = Routing::Map.new

  def self.routes
    @@routes
  end
end
