require "db"
require "pg"
require "crinja"

require "./base_store"
require "./validation/validation"
require "./persistence_klazz"
require "./persistence"

module Calm
  module Db
    abstract class Base
      include Crinja::Object::Auto
      include Calm::Db::BaseStore
      extend Calm::Db::PersistenceKlazz
      include Calm::Db::Persistence
      include Calm::Db::Validation
    end
  end
end
