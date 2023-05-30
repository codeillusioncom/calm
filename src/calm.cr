require "./http/context"
require "./http/*"
require "./http/handlers/*"
require "./http/routing/**"

# TODO: Write documentation for `Calm`
module Calm
  VERSION = "0.1.0"

  @@routes : Routing::Map = Routing::Map.new

  def self.routes
    @@routes
  end
end

Calm::Http::Server.start
