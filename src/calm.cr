require "crinja"
require "i18n"
require "sentry"

require "./i18n/i18n"
require "./config/locales/*"
require "./cli/**"
require "./db/**"
require "./http/context"
require "./http/*"
require "./http/controllers/format/*"
require "./http/controllers/*"
require "./http/handlers/*"
require "./http/policies/*"
require "./http/response/*"
require "./http/routing/**"
require "./http/views/**"
require "./settings/**"
require "./support/*"
require "./ui/**"

# TODO: Write documentation for `Calm`
module Calm
  VERSION = "0.1.0"

  @@env : Env?
  @@routes : Calm::Routes = Calm::Routes.new
  @@settings : Calm::Settings?

  def self.env
    @@env ||= Env.new
  end

  def self.routes
    @@routes
  end

  def self.routes=(value)
    @@routes = value
  end

  def self.settings
    @@settings ||= Calm::Settings.new
  end

  def run
    Log.info { "Starting." }
    Signal::INT.trap do
      puts "terminating..."
      Signal::INT.reset
      Log.info { "Exited by user." }

      exit
    end

    Cli.new(options: ARGV).run
  end
end
