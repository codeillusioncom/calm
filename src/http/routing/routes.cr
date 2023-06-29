module Calm
  class Routes
    getter routes

    def initialize
      @routes = [] of Calm::Route
    end

    macro get_post(route, mapping, type, view)
      def self.{{mapping.id.underscore.gsub(/\./, "__")}}
        {{route}}
      end

      route = Calm::Route.new({{route}}, {{type}}) do |context|
        {{mapping.receiver}}.new.{{mapping.name}}(context)
      end

      route.access = ->(username : String?, object : Calm::Db::Base?){({{mapping.receiver}}Policy.new(username, object).{{mapping.name}}?)}

      # TODO: choose view
      {% if view %}
        route.view = ->(context: HTTP::Server::Context, args : Hash(String, String | Int32)){({{view.receiver}}.new.{{mapping.name}}(context, args)) || "" }
      {% else %}
        route.view = ->(context: HTTP::Server::Context, args : Hash(String, String | Int32)){({{mapping.receiver}}View.new.{{mapping.name}}(context, args)) || "" }
      {% end %}

      Calm.routes.routes << route
    end

    macro get(route, mapping, view = nil)
      get_post({{route}}, {{mapping}}, "get", {{view}})
    end

    macro post(route, mapping, view = nil)
      get_post({{route}}, {{mapping}}, "post", {{view}})
    end
  end
end
