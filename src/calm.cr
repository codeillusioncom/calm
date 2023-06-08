require "crinja"
require "sentry"

require "./cli/**"
require "./db/**"
require "./http/context"
require "./http/*"
require "./http/handlers/format/*"
require "./http/handlers/*"
require "./http/policies/*"
require "./http/response/*"
require "./http/routing/**"
require "./settings/**"

# TODO: Write documentation for `Calm`
module Calm
  VERSION = "0.1.0"

  @@env : Env?
  @@routes : Routing::Map = Routing::Map.new
  @@settings : Calm::Settings?

  def self.env
    @@env ||= Env.new
  end

  def self.routes
    @@routes
  end

  def self.settings
    @@settings ||= Calm::Settings.new
  end

  def run
    Log.info { "Starting." }
    Signal::INT.trap do
      Signal::INT.reset
      Log.info { "Exited by user." }

      exit
    end

    Cli.new(options: ARGV).run
  end
end
