module Calm
  class Route
    getter path
    getter callback
    getter type
    property view : Proc(HTTP::Server::Context, Hash(String, Any), String)
    property access : Proc(String?, Calm::Db::Base?, Bool)

    def initialize(@path : String, @type : String = "get", &@callback : HTTP::Server::Context -> String)
      @view = Proc(HTTP::Server::Context, Hash(String, Any), String).new { |context, args| "" }
      @access = Proc(String?, Calm::Db::Base?, Bool).new { |username, object| false }
    end
  end
end
