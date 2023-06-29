module Calm
  class Route
    getter path
    getter callback
    getter type
    alias ParamsHash = String | Int32
    property view : Proc(HTTP::Server::Context, Hash(String, ParamsHash), String)
    property access : Proc(String?, Calm::Db::Base?, Bool)

    def initialize(@path : String, @type : String = "get", &@callback : HTTP::Server::Context -> String)
      @view = Proc(HTTP::Server::Context, Hash(String, String | Int32), String).new { |args| "" }
      @access = Proc(String?, Calm::Db::Base?, Bool).new { |username, object| false }
    end
  end
end
